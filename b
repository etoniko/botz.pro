(function () {
  'use strict';
  const CLIENTS_MAX_BOTS = 200;

  /* =========================
   *  Core data structures
   * ========================= */
  class Entity {
    constructor() {
      this.id = 0;
      this.x = 0;
      this.y = 0;
      this.extraData = 0;
      this.flags = 0;
      this.size = 0;
      this.name = "";
      this.isVirus = false;
      this.isPellet = false;
      this.isFriend = false;
    }
  }
  class Reader {
    constructor(buffer) {
      this.dataView = new DataView(buffer);
      this.byteOffset = 0;
    }
    readUint8() { return this.dataView.getUint8(this.byteOffset++); }
    readUint16() { const v = this.dataView.getUint16(this.byteOffset, true); this.byteOffset += 2; return v; }
    readInt32() { const v = this.dataView.getInt32(this.byteOffset, true); this.byteOffset += 4; return v; }
    readUint32() { const v = this.dataView.getUint32(this.byteOffset, true); this.byteOffset += 4; return v; }
    readFloat64() { const v = this.dataView.getFloat64(this.byteOffset, true); this.byteOffset += 8; return v; }
    readString() {
      let s = "";
      for (;;) {
        const c = this.readUint8();
        if (c === 0) break;
        s += String.fromCharCode(c);
      }
      return s;
    }
  }
  class Writer {
    constructor(size) {
      this.size = size || 1000;
      this.dataView = new DataView(new ArrayBuffer(this.size));
      this.byteOffset = 0;
    }
    ensureCapacity(plus) {
      if (this.byteOffset + plus > this.dataView.buffer.byteLength) {
        const nb = new ArrayBuffer(this.dataView.buffer.byteLength * 2);
        new Uint8Array(nb).set(new Uint8Array(this.dataView.buffer));
        this.dataView = new DataView(nb);
        this.size = nb.byteLength;
      }
    }
    writeUint8(v) { this.ensureCapacity(1); this.dataView.setUint8(this.byteOffset++, v); }
    writeInt32(v) { this.ensureCapacity(4); this.dataView.setInt32(this.byteOffset, v, true); this.byteOffset += 4; }
    writeUint32(v) { this.ensureCapacity(4); this.dataView.setUint32(this.byteOffset, v, true); this.byteOffset += 4; }
    writeString(str) {
      const utf8 = new TextEncoder().encode(str);
      this.ensureCapacity(utf8.length + 1);
      for (let i = 0; i < utf8.length; i++) this.writeUint8(utf8[i]);
      this.writeUint8(0);
    }
  }

  /* =========================
   *  Bot client
   * ========================= */
  class Bot {
    constructor(config) {
      this.config = config;
      this.ws = null;
      this.offsetX = 0;
      this.offsetY = 0;
      this.moveInt = null;
      this.stopped = false;
      this.isAlive = false;
      this.connected = false;
      this.playerCells = [];
      this.encryptionKey = 0;
      this.decryptionKey = 0;
      this.serverVersion = null;
      this.followMouse = false;
      this.myCellIDs = [];
      this.errorTimeout = null;
      this.clientVersion = 31116;
      this.protocolVersion = 23;
      this.reconnectTimeout = null;
      this.followMouseTimeout = null;
      this.playerPos = { x: 0, y: 0 };
      this.isReconnecting = false;
      this.lastActiveTime = Date.now();
      this.connectionAttempts = 0;
      this.maxConnectionAttempts = 8;
      this.ghostCells = [];
      this.targetX = null;
      this.targetY = null;

      this.name = '𝗵𝘁𝘁𝗽𝘀://𝗯𝗼𝘁𝘇.𝗽𝗿𝗼';

      this.connect();
    }

    reset() {
      this.ws = null; this.offsetX = 0; this.offsetY = 0;
      this.isAlive = false; this.connected = false;
      this.playerCells = []; this.encryptionKey = 0; this.decryptionKey = 0;
      this.serverVersion = null; this.followMouse = false; this.myCellIDs = [];
      this.errorTimeout = null; this.followMouseTimeout = null;
      this.targetX = null; this.targetY = null;
    }

    connect() {
      if (this.connectionAttempts >= this.maxConnectionAttempts) { this.stop(); return; }
      this.connectionAttempts++; this.reset();
      if (!this.stopped) {
        this.ws = new WebSocket(this.config.agarServer);
        this.ws.binaryType = "arraybuffer";
        this.ws.onopen = this.onopen.bind(this);
        this.ws.onclose = this.onclose.bind(this);
        this.ws.onerror = this.onerror.bind(this);
        this.ws.onmessage = this.onmessage.bind(this);
        this.connected = true;
        this.lastActiveTime = Date.now();
      }
    }

    onopen() {
      this.lastActiveTime = Date.now();
      this.connectionAttempts = 0;
      this.sendProtocolVersion();
      this.sendClientVersion();
    }
    onclose() { this.connected = false; this.handleReconnection(); }
    onerror() {
      this.errorTimeout = setTimeout(() => {
        if (this.ws?.readyState === WebSocket.CONNECTING || this.ws?.readyState === WebSocket.OPEN) this.ws.close();
      }, 1000);
    }

    send(data) {
      if (this.ws && this.ws.readyState === WebSocket.OPEN) {
        if (this.encryptionKey) {
          data = this.xorBuffer(data, this.encryptionKey);
          this.encryptionKey = this.rotateKey(this.encryptionKey);
        }
        this.ws.send(data);
        this.lastActiveTime = Date.now();
      }
    }

    onmessage(event) {
      this.lastActiveTime = Date.now();
      let data = event.data;
      if (this.decryptionKey) data = this.xorBuffer(data, this.decryptionKey ^ this.clientVersion);
      this.handleBuffer(data);
    }

    handleBuffer(buffer) {
      const r = new Reader(buffer);
      switch (r.readUint8()) {
        case 32: {
          this.myCellIDs.push(r.readUint32());
          if (!this.isAlive) {
            this.isAlive = true;
            if (!this.config.startedBots && this.config.stoppedBots) this.config.startedBots = true;
          }
          this.moveInt = setInterval(() => this.move(this.config.cords), 17);
          if (!this.followMouseTimeout) {
            this.followMouseTimeout = setTimeout(() => { if (this.isAlive) this.followMouse = true; }, 16000);
          }
          break;
        }
        case 241: {
          this.decryptionKey = r.readUint32();
          this.serverVersion = r.readString();
          const m = this.config.agarServer.match(/wss:\/\/(web-arenas-live-[\w-]+\.agario\.miniclippt\.com\/[\w-]+\/[\d-]+)/);
          if (m) this.encryptionKey = this.murmur2("" + m[1] + this.serverVersion, 255);
          break;
        }
        case 242: this.sendSpawn(); break;
        case 255: {
          const dv = new DataView(buffer);
          const outLen = dv.getUint32(1, true);
          const un = this.uncompressMessage(new Uint8Array(dv.buffer.slice(5)), new Uint8Array(outLen)).buffer;
          this.handleMessage(un);
          break;
        }
      }
    }

    handleMessage(buffer) {
      const r = new Reader(buffer);
      switch (r.readUint8()) {
        case 16: this.updateNodes(r); break;
        case 64: this.updateOffset(r); break;
      }
    }

    updateOffset(r) {
      const minX = r.readFloat64();
      const minY = r.readFloat64();
      const maxX = r.readFloat64();
      const maxY = r.readFloat64();
      if (maxX - minX > 14000) this.offsetX = (maxX + minX) / 2;
      if (maxY - minY > 14000) this.offsetY = (maxY + minY) / 2;
    }

    updateNodes(r) {
      const nodeCount = r.readUint16();
      for (let i = 0; i < nodeCount; i++) r.byteOffset += 8;

      for (;;) {
        const id = r.readUint32();
        if (id === 0) break;
        const e = new Entity();
        e.id = id;
        e.x = r.readInt32();
        e.y = r.readInt32();
        e.size = r.readUint16();
        const flags = r.readUint8();
        const ext = flags & 128 ? r.readUint8() : 0;
        if (flags & 1) e.isVirus = true;
        if (flags & 2) r.byteOffset += 3;
        if (flags & 4) r.readString();
        if (flags & 8) e.name = decodeURIComponent(escape(r.readString()));
        if (ext & 1) e.isPellet = true;
        if (ext & 2) e.isFriend = true;
        if (ext & 4) r.byteOffset += 4;
        this.playerCells[e.id] = e;
      }

      const removed = r.readUint16();
      for (let i = 0; i < removed; i++) {
        const rmId = r.readUint32();
        if (this.myCellIDs.includes(rmId)) this.myCellIDs.splice(this.myCellIDs.indexOf(rmId), 1);
        delete this.playerCells[rmId];
      }

      if (this.isAlive && this.myCellIDs.length === 0) {
        this.isAlive = false;
        if (this.followMouseTimeout) { clearTimeout(this.followMouseTimeout); this.followMouseTimeout = null; }
        this.followMouse = false;
        this.sendSpawn();
      }
    }

    calculateDistance(x1, y1, x2, y2) { return Math.hypot(x2 - x1, y2 - y1); }

    move({ x, y }) {
      if (this.lastMoveTime && Date.now() - this.lastMoveTime < 100) return;
      this.lastMoveTime = Date.now();

      const avg = { x: 0, y: 0, size: 0 };
      const { minAvoidDistance, escapeDistance, virusAvoidDistance } = this.config;

      this.myCellIDs.forEach(id => {
        const c = this.playerCells[id];
        if (c) {
          avg.x += c.x / this.myCellIDs.length;
          avg.y += c.y / this.myCellIDs.length;
          avg.size += c.size;
        }
      });

      let closestPellet = null, closestPelletDist = Infinity;
      let closestVirus = null, closestVirusDist = Infinity;
      let closestBigger = null, closestBiggerDist = Infinity;

      for (const e of Object.values(this.playerCells)) {
        let pick = false;
        const d = this.calculateDistance(avg.x, avg.y, e.x, e.y);
        if (!e.isFriend && !e.isVirus && e.isPellet && !e.name) {
          pick = true;
        } else if (!e.isPellet && !e.isFriend && e.isVirus && !e.name) {
          if (d < closestVirusDist) { closestVirusDist = d; closestVirus = e; }
        } else if (!e.isVirus && !e.isPellet && !e.isFriend && e.name.length > 0 && e.size > avg.size * 1.15) {
          pick = true;
        } else if (!e.isFriend && !e.isVirus && !e.isPellet && e.name.length === 0 && e.size > avg.size && d < closestBiggerDist) {
          closestBiggerDist = d; closestBigger = e;
        }
        if (pick && d < closestPelletDist) { closestPelletDist = d; closestPellet = e; }
      }

      const detectionRange = avg.size * 1.5;

      if (this.config.vShield && avg.size >= 133 && closestVirus) {
        this.moveTo(closestVirus.x, closestVirus.y, this.decryptionKey); return;
      }

      if (!this.targetX || !this.targetY) { this.targetX = avg.x; this.targetY = avg.y; }

      if (closestBigger && closestBiggerDist < 50 + detectionRange) {
        const ang = Math.atan2(avg.y - closestBigger.y, avg.x - closestBigger.x);
        const ax = avg.x + Math.floor(escapeDistance * Math.cos(ang));
        const ay = avg.y + Math.floor(escapeDistance * Math.sin(ang));
        this.targetX = this.targetX * 0.7 + ax * 0.3;
        this.targetY = this.targetY * 0.7 + ay * 0.3;
        this.moveTo(this.targetX, this.targetY, this.decryptionKey); return;
      }

      if (!this.followMouse && !this.config.vShield && this.config.botAi && closestVirus && closestVirusDist < virusAvoidDistance && avg.size >= closestVirus.size * minAvoidDistance) {
        const ang = Math.atan2(avg.y - closestVirus.y, avg.x - closestVirus.x);
        const ax = avg.x + Math.floor(virusAvoidDistance * Math.cos(ang));
        const ay = avg.y + Math.floor(virusAvoidDistance * Math.sin(ang));
        this.targetX = this.targetX * 0.7 + ax * 0.3;
        this.targetY = this.targetY * 0.7 + ay * 0.3;
        this.moveTo(this.targetX, this.targetY, this.decryptionKey); return;
      }

      if (this.followMouse && !this.config.botAi && avg.size >= 85) {
        this.targetX = this.targetX * 0.7 + (x + this.offsetX) * 0.3;
        this.targetY = this.targetY * 0.7 + (y + this.offsetY) * 0.3;
        this.moveTo(this.targetX, this.targetY, this.decryptionKey); return;
      }

      if (closestPellet && closestPellet.isPellet) {
        if (this.config.botAi && closestVirus &&
            this.calculateDistance(closestPellet.x, closestPellet.y, closestVirus.x, closestVirus.y) < virusAvoidDistance &&
            avg.size >= closestVirus.size * minAvoidDistance) {
          let alt = null, altD = Infinity;
          for (const p of Object.values(this.playerCells)) {
            if (!p.isFriend && !p.isVirus && p.isPellet && !p.name) {
              const dv = this.calculateDistance(p.x, p.y, closestVirus.x, closestVirus.y);
              if (dv >= virusAvoidDistance) {
                const dc = this.calculateDistance(avg.x, avg.y, p.x, p.y);
                if (dc < altD) { altD = dc; alt = p; }
              }
            }
          }
          if (alt) {
            this.targetX = this.targetX * 0.7 + alt.x * 0.3;
            this.targetY = this.targetY * 0.7 + alt.y * 0.3;
            this.moveTo(this.targetX, this.targetY, this.decryptionKey);
          } else {
            const rx = Math.floor(Math.random() * 1337);
            const ry = Math.floor(Math.random() * 1337);
            const dir = Math.random() > 0.5;
            this.targetX = this.targetX * 0.7 + (avg.x + (dir ? rx : -rx)) * 0.3;
            this.targetY = this.targetY * 0.7 + (avg.y + (dir ? -ry : ry)) * 0.3;
            this.moveTo(this.targetX, this.targetY, this.decryptionKey);
          }
        } else {
          this.targetX = this.targetX * 0.7 + closestPellet.x * 0.3;
          this.targetY = this.targetY * 0.7 + closestPellet.y * 0.3;
          this.moveTo(this.targetX, this.targetY, this.decryptionKey);
        }
        return;
      }

      const rx = Math.floor(Math.random() * 1337);
      const ry = Math.floor(Math.random() * 1337);
      const dir = Math.random() > 0.5;
      this.targetX = this.targetX * 0.7 + (avg.x + (dir ? rx : -rx)) * 0.3;
      this.targetY = this.targetY * 0.7 + (avg.y + (dir ? -ry : ry)) * 0.3;
      this.moveTo(this.targetX, this.targetY, this.decryptionKey);
    }

    /* protocol */
    sendProtocolVersion() { const w = new Writer(5); w.writeUint8(254); w.writeUint32(this.protocolVersion); if (this.ws) this.ws.send(new Uint8Array(w.dataView.buffer).buffer); }
    sendClientVersion()  { const w = new Writer(5); w.writeUint8(255); w.writeUint32(this.clientVersion); if (this.ws) this.ws.send(new Uint8Array(w.dataView.buffer).buffer); }
    sendSpawn() {
      const w = new Writer(this.name.length * 3);
      w.writeUint8(0); w.writeString(this.name);
      this.send(new Uint8Array(w.dataView.buffer).buffer);
    }
    moveTo(x, y, key) {
      const w = new Writer(13);
      w.writeUint8(16); w.writeInt32(x); w.writeInt32(y); w.writeUint32(key);
      this.send(new Uint8Array(w.dataView.buffer).buffer);
    }
    split() { this.send(new Uint8Array([17]).buffer); }
    eject() { this.send(new Uint8Array([21]).buffer); }

    /* helpers */
    rotateKey(key) { key = Math.imul(key, 1540483477) >> 0; key = Math.imul(key >>> 24 ^ key, 1540483477) >> 0 ^ 114296087; key = Math.imul(key >>> 13 ^ key, 1540483477) >> 0; return key >>> 15 ^ key; }
    xorBuffer(buffer, key) { const dv = new DataView(buffer); for (let i = 0; i < dv.byteLength; i++) dv.setUint8(i, dv.getUint8(i) ^ key >>> i % 4 * 8 & 255); return buffer; }
    uncompressMessage(comp, out) {
      for (let i = 0, j = 0; i < comp.length;) {
        const token = comp[i++];
        let lit = token >> 4;
        if (lit > 0) {
          let ext = lit + 240;
          for (; ext === 255;) { ext = comp[i++]; lit += ext; }
          const end = i + lit;
          for (; i < end;) out[j++] = comp[i++];
          if (i === comp.length) return out;
        }
        const off = comp[i++] | comp[i++] << 8;
        if (off === 0 || off > j) return -(i - 2);
        let m = token & 15;
        let ext = m + 240;
        for (; ext === 255;) { ext = comp[i++]; m += ext; }
        let p = j - off;
        const end = j + m + 4;
        for (; j < end;) out[j++] = out[p++];
      }
      return out;
    }
    murmur2(str, seed) {
      let len = str.length, h = seed ^ len, i = 0, k;
      while (len >= 4) {
        k = str.charCodeAt(i) & 255 | (str.charCodeAt(++i) & 255) << 8 | (str.charCodeAt(++i) & 255) << 16 | (str.charCodeAt(++i) & 255) << 24;
        k = (k & 65535) * 1540483477 + (((k >>> 16) * 1540483477 & 65535) << 16); k ^= k >>> 24;
        k = (k & 65535) * 1540483477 + (((k >>> 16) * 1540483477 & 65535) << 16);
        h = (h & 65535) * 1540483477 + (((h >>> 16) * 1540483477 & 65535) << 16) ^ k;
        len -= 4; ++i;
      }
      switch (len) {
        case 3: h ^= (str.charCodeAt(i + 2) & 255) << 16;
        case 2: h ^= (str.charCodeAt(i + 1) & 255) << 8;
        case 1: h ^= str.charCodeAt(i) & 255;
          h = (h & 65535) * 1540483477 + (((h >>> 16) * 1540483477 & 65535) << 16);
      }
      h ^= h >>> 13; h = (h & 65535) * 1540483477 + (((h >>> 16) * 1540483477 & 65535) << 16); h ^= h >>> 15;
      return h >>> 0;
    }
    clearIntervals() { clearInterval(this.moveInt); }
    clearTimeouts() { if (this.errorTimeout !== null) clearTimeout(this.errorTimeout); if (this.reconnectTimeout !== null) clearTimeout(this.reconnectTimeout); }
    handleReconnection() {
      if (!this.isReconnecting && !this.stopped && !this.config.stoppedBots) {
        this.isReconnecting = true;
        const base = Math.min(500 * Math.pow(1.5, this.connectionAttempts), 10000);
        const jitter = Math.random() * 200 - 100;
        this.reconnectTimeout = setTimeout(() => { this.isReconnecting = false; this.connect(); }, base + jitter);
      }
    }
    stop() {
      this.clearTimeouts(); this.clearIntervals();
      if (this.ws) {
        this.ws.onopen = null; this.ws.onclose = null; this.ws.onerror = null; this.ws.onmessage = null;
        if (this.ws.readyState === WebSocket.OPEN || this.ws.readyState === WebSocket.CONNECTING) this.ws.close();
        this.ws = null;
      }
      this.stopped = true; this.connected = false;
    }
    checkConnectionTimeout() {
      if (this.connected && Date.now() - this.lastActiveTime > 5000) {
        this.stop(); this.handleReconnection();
      }
    }
  }

  /* =========================
   *  Manager & config
   * ========================= */
  let botCounter = null;
  let botCreationInterval = null;
  let botReplacementInterval = null;
  let connectionTimeoutInterval = null;
  let isStarting = false;

  const botConfig = {
    botAi: false,
    keybinds: { modeKey: "F", feedKey: "C", splitKey: "X", vShieldKey: "V" },
    cords: { x: 0, y: 0 },
    botCount: parseInt(localStorage.getItem('botAmount')) || 150,
    agarServer: null,
    stoppedBots: true,
    startedBots: false,
    vShield: false,
    minAvoidDistance: 1.1,
    escapeDistance: 700,
    virusAvoidDistance: 300
  };
  const Bots = [];

  function startBots(action) {
    if (isStarting) return;

    if (action === 'stfinish' && !botConfig.startedBots && botConfig.stoppedBots) {
      isStarting = true;
      botConfig.botAi = false;
      botConfig.startedBots = true;
      botConfig.stoppedBots = false;
      updateBotCount();

      let startTime = Date.now();
      let stopwatchInterval = setInterval(() => {
        if (!botConfig.startedBots) { clearInterval(stopwatchInterval); return; }
        const elapsed = Date.now() - startTime;
        const h = Math.floor(elapsed / 3600000);
        const m = Math.floor((elapsed % 3600000) / 60000);
        const s = Math.floor((elapsed % 60000) / 1000);
        const el = document.querySelector("#stopwatch");
        if (el) el.textContent = h > 0 ? `${String(h).padStart(2, '0')}:${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}` : `${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`;
      }, 1000);

      botCounter = setInterval(() => {
        const alive = Bots.filter(b => b.isAlive).length;
        const connected = Bots.filter(b => b.connected).length;
        setText(".saud-botCount", `${connected}-${alive}`);
        setText("#status", "Started");
        setClass("#status-light", "status-indicator status-running");

        // info enrichment
        setText("#sv-server", botConfig.agarServer || "—");
        const any = Bots.find(b => b.serverVersion);
        setText("#sv-versions", any ? `Proto ${any.protocolVersion} • Client ${any.clientVersion} • Server ${any.serverVersion}` : `Proto 23 • Client 31116 • Server —`);
        setText("#sv-modes", `AI: ${botConfig.botAi ? 'ON' : 'OFF'} • VShield: ${botConfig.vShield ? 'ON' : 'OFF'}`);
      }, 300);

      botReplacementInterval = setInterval(replaceDisconnectedBots, 2000);
      connectionTimeoutInterval = setInterval(() => Bots.forEach(b => b.checkConnectionTimeout()), 5000);

      // UI buttons
      show(".saud-stop", true);
      show(".saud-stfinish", false);
      setClass("#status-light", "status-indicator status-running");
      show("#stopwatch", true);
      isStarting = false;

    } else if (action === 'stop' && botConfig.startedBots) {
      Bots.forEach(b => b.stop());
      Bots.length = 0;
      clearInterval(botCounter);
      clearInterval(botReplacementInterval);
      clearInterval(connectionTimeoutInterval);
      botCounter = botReplacementInterval = connectionTimeoutInterval = null;

      botConfig.botAi = false;
      botConfig.stoppedBots = true;
      botConfig.startedBots = false;

      show(".saud-stfinish", true);
      show(".saud-stop", false);
      setText(".saud-botCount", `${botConfig.botCount}`);
      setText("#status", "Stopped");
      setClass("#status-light", "status-indicator status-stopped");
      const sw = qs("#stopwatch"); if (sw) { sw.style.display = "none"; sw.textContent = "00:00"; }
    }
  }

  function updateBotCount() {
    if (!botConfig.startedBots) return;
    clearInterval(botCreationInterval);
    const current = Bots.length;
    const target = Math.min(botConfig.botCount, CLIENTS_MAX_BOTS);

    if (current < target) {
      let count = current;
      botCreationInterval = setInterval(() => {
        if (count < target && botConfig.startedBots && count < CLIENTS_MAX_BOTS) {
          const b = new Bot(botConfig);
          Bots.push(b);
          count++;
        } else {
          clearInterval(botCreationInterval);
          botCreationInterval = null;
        }
      }, 100);
    } else if (current > target) {
      while (Bots.length > target) {
        const b = Bots.pop();
        b.stop();
      }
    }
  }

  function replaceDisconnectedBots() {
    if (!botConfig.startedBots) return;
    const target = Math.min(botConfig.botCount, CLIENTS_MAX_BOTS);
    const bad = Bots.filter(b => !b.connected || b.connectionAttempts >= b.maxConnectionAttempts);

    bad.forEach(b => {
      b.stop();
      const i = Bots.indexOf(b);
      if (i !== -1) Bots.splice(i, 1);
    });

    const need = Math.min(target - Bots.length, 10);
    for (let i = 0; i < need; i++) {
      if (Bots.length < target && botConfig.startedBots) {
        const b = new Bot(botConfig);
        Bots.push(b);
      }
    }
  }

  /* =========================
   *  UI
   * ========================= */
  const panelId = "agarsubots_" + Math.floor(100 + Math.random() * 900);

  function createContainer() {
    let c = document.getElementById(panelId);
    if (!c) {
      c = document.createElement("div");
      c.id = panelId;
      c.style.position = "absolute";
      c.style.zIndex = "99999999";
      (document.body || document.documentElement).appendChild(c);
    }
    return c;
  }

  function loadStyles() {
    const css = `
    :root{
      --panel-w: 296px; --r-lg:16px; --r-md:12px; --r-sm:10px;
      --bg1:12 16 28; --bg2:18 24 42; --txt:231 93% 96%; --muted:220 10% 70%;
      --border:220 18% 22%; --brand1:206 100% 55%; --brand2:215 100% 50%;
      --good:147 100% 46%; --warn:48 100% 56%; --bad:0 100% 62%;
      --shadow:0 15px 40px rgba(0,0,0,.35); --blur:12px;
    }
    .panel{
      position:fixed; top:50%; left:18px; transform:translateY(-50%);
      width:var(--panel-w); display:flex; flex-direction:column; gap:12px;
      padding:14px; color:hsl(var(--txt));
      background:linear-gradient(180deg, rgba(var(--bg1)/.92), rgba(var(--bg2)/.88));
      border:1px solid hsl(var(--border)); border-radius:var(--r-lg);
      backdrop-filter:blur(var(--blur)); box-shadow:var(--shadow); user-select:none;
      font-family:ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
    }
    .panel::before{content:""; position:absolute; inset:0; border-radius:inherit; pointer-events:none;
      box-shadow: inset 0 0 0 1px rgba(255,255,255,.04), inset 0 0 50px rgba(255,255,255,.03);
    }
    .row{ display:flex; align-items:center; justify-content:space-between; gap:10px; }
    .brand{ display:flex; align-items:center; gap:10px; }
    .logo{width: 32px;
    height: 32px;
    border-radius: 10px;
    background: url(https://agar.su/icon.svg);
    background-size: cover;
    }
    .ttl{ line-height:1.05; }
    .ttl .t1{ font-weight:800; font-size:14px; letter-spacing:.2px; color:#fff; }
    .ttl .t2{ font-size:12px; color:hsl(var(--muted)); }

    .status{ display:flex; align-items:center; gap:8px; padding:6px 10px; font-size:12px; border-radius:999px;
      background: rgba(255,255,255,.06); border:1px solid rgba(255,255,255,.12);
    }
    .dot{ width:10px; height:10px; border-radius:50%; box-shadow:0 0 0 3px rgba(255,255,255,.06) inset; }
    .running{ background:hsl(var(--good)); box-shadow:0 0 10px rgba(0,255,127,.6); }
    .stopped{ background:hsl(var(--warn)); box-shadow:0 0 10px rgba(255,215,0,.55); }
    .offline{ background:hsl(var(--bad));  box-shadow:0 0 10px rgba(255,77,77,.55); }

    .stats{ display:grid; grid-template-columns:1fr; gap:8px; }
    .card{ display:flex; flex-direction:column; gap:4px; padding:10px; border-radius:var(--r-md);
      background:linear-gradient(180deg, rgba(255,255,255,.045), rgba(255,255,255,.02));
      border:1px solid rgba(255,255,255,.10);
    }
    .label{ font-size:12px; color:hsl(var(--muted)); letter-spacing:.2px; }
    .value{ font-size:13px; font-weight:800; color:#fff; }

    .controls{ display:grid; grid-template-columns:1fr 1fr; gap:8px; }
    .btn{
      display:inline-flex; align-items:center; justify-content:center; gap:6px;
      padding:10px 12px; border-radius:var(--r-md); font-weight:800; font-size:12px; letter-spacing:.25px;
      background:linear-gradient(180deg, rgba(255,255,255,.12), rgba(255,255,255,.06));
      border:1px solid rgba(255,255,255,.16); color:#fff;
      transition: transform .12s ease, box-shadow .15s ease, background .2s ease, border-color .2s ease;
    }
    .btn:hover{ transform:translateY(-1px); box-shadow:0 8px 18px rgba(0,0,0,.25); }
    .btn:active{ transform:translateY(0); }
    .primary{ background:linear-gradient(180deg, hsl(var(--brand1)), hsl(var(--brand2))); border-color:rgba(0,122,255,.55); }
    .danger{ background:linear-gradient(180deg, hsl(var(--bad)), color-mix(in srgb, hsl(var(--bad)) 85%, black)); border-color:rgba(255,77,77,.5); }
    .ghost{ background:transparent; border-color:rgba(255,255,255,.16); }
    .toggle.active{ background:linear-gradient(180deg, hsl(var(--good)), color-mix(in srgb, hsl(var(--good)) 78%, black)); border-color:rgba(0,209,160,.55); }

    .footer{ display:flex; align-items:center; justify-content:space-between; gap:10px; margin-top:-2px; }
    .stopwatch{ font-size:12px; color:hsl(var(--muted)); display:none; }

    @media (max-height:680px){ .panel{ top:18px; transform:none; } }
    @media (max-width:520px){ .panel{ left:12px; width:calc(100vw - 24px);} }
    `;
    const style = document.createElement("style");
    style.type = "text/css";
    style.textContent = css;
    document.head.appendChild(style);
  }

  function buildPanel() {
    const html = `
      <div class="panel" id="saud-panel" role="complementary" aria-label="Bot control panel">
        <div class="row">
          <div class="brand">
            <div class="logo" aria-hidden="true"></div>
            <div class="ttl">
              <div class="t1">AGAR.SU Bots</div>
              <div class="t2">Control Center</div>
            </div>
          </div>
          <div class="status" title="Current status">
            <span class="dot stopped" id="status-light" aria-hidden="true"></span>
            <span id="status">Stopped</span>
          </div>
        </div>

        <div class="stats">
          <div class="card">
            <div class="label">Bots (Connected — Alive)</div>
            <div class="value"><span class="saud-botCount">${botConfig.botCount}</span></div>
          </div>
          <div class="card">
            <div class="label">Server</div>
            <div class="value" id="sv-server">—</div>
          </div>
          <div class="card">
            <div class="label">Versions</div>
            <div class="value" id="sv-versions">Proto 23 • Client 31116 • Server —</div>
          </div>
          <div class="card">
            <div class="label">Modes</div>
            <div class="value" id="sv-modes">AI: OFF • VShield: OFF</div>
          </div>
        </div>

        <div class="controls">
          <button class="btn primary saud-stfinish">Start</button>
          <button class="btn danger saud-stop" style="display:none;">Stop</button>
          <button id="btn-ai" class="btn ghost toggle">AI OFF</button>
          <button id="btn-vshield" class="btn ghost toggle">VShield OFF</button>
        </div>

        <div class="footer">
          <div class="stopwatch" id="stopwatch">00:00</div>
          <div class="value" style="opacity:.6; font-weight:300;">C - Split,  X - Eject, V - Virus</div>
        </div>
      </div>
    `;
    const container = createContainer();
    container.innerHTML = html;

    // hook buttons
    const startBtn = qs(".saud-stfinish");
    const stopBtn  = qs(".saud-stop");
    const aiBtn    = qs("#btn-ai");
    const vsBtn    = qs("#btn-vshield");

    startBtn?.addEventListener("click", () => startBots('stfinish'));
    stopBtn?.addEventListener("click",  () => startBots('stop'));
    aiBtn?.addEventListener("click", () => window.toggleAIMode());
    vsBtn?.addEventListener("click", () => window.toggleVShield());
  }

  /* helpers for UI */
  const qs = s => document.querySelector(s);
  const setText = (sel, txt) => { const el = qs(sel); if (el) el.textContent = txt; };
  const setClass = (sel, cls) => { const el = qs(sel); if (el) el.className = cls; };
  const show = (sel, vis) => { const el = qs(sel); if (el) el.style.display = vis ? "" : "none"; };

  /* =========================
   *  UI actions (toggles)
   * ========================= */
  window.toggleVShield = () => {
    botConfig.vShield = !botConfig.vShield;
    const b = qs("#btn-vshield");
    if (b) { b.textContent = `VShield ${botConfig.vShield ? 'ON' : 'OFF'}`; b.classList.toggle('toggle'); b.classList.toggle('active', botConfig.vShield); }
    setText("#sv-modes", `AI: ${botConfig.botAi ? 'ON' : 'OFF'} • VShield: ${botConfig.vShield ? 'ON' : 'OFF'}`);
  };
  window.toggleAIMode = () => {
    botConfig.botAi = !botConfig.botAi;
    const b = qs("#btn-ai");
    if (b) { b.textContent = `AI ${botConfig.botAi ? 'ON' : 'OFF'}`; b.classList.toggle('toggle'); b.classList.toggle('active', botConfig.botAi); }
    setText("#sv-modes", `AI: ${botConfig.botAi ? 'ON' : 'OFF'} • VShield: ${botConfig.vShield ? 'ON' : 'OFF'}`);
  };

  /* =========================
   *  WS hook to catch server
   * ========================= */
  function initWebSocketHook() {
    const allowed = ["delt.io", "ixagar", "glitch", "socket.io", "firebase", "agartool.io", "agar.io", "agar.su"];
    const allow = url => allowed.some(d => url.includes(d));
    if (!WebSocket.prototype._originalSend) {
      WebSocket.prototype._originalSend = WebSocket.prototype.send;
      WebSocket.prototype.send = function (data) {
        if (!allow(this.url)) botConfig.agarServer = this.url;
        WebSocket.prototype._originalSend.call(this, data);
      };
    }
  }

  /* =========================
   *  Mouse source
   * ========================= */
  function initCursorTrack() {
    setInterval(() => {
      if (window?.unitManager?.activeUnit?.cursor) {
        botConfig.cords.x = window.unitManager.activeUnit.cursor.x;
        botConfig.cords.y = window.unitManager.activeUnit.cursor.y;
      } else if (window?.mouse) {
        botConfig.cords.x = window.mouse.x;
        botConfig.cords.y = window.mouse.y;
      }
    }, 50);
  }

  /* =========================
   *  Keybinds
   * ========================= */
  function initKeybinds() {
    document.addEventListener('keydown', (e) => {
      const k = e.key.toUpperCase();
      if (k === botConfig.keybinds.modeKey) {
        window.toggleAIMode();
      } else if (k === botConfig.keybinds.vShieldKey) {
        window.toggleVShield();
      } else if (k === botConfig.keybinds.splitKey) {
        Bots.forEach(b => { if (b.isAlive && b.connected) b.split(); });
      } else if (k === botConfig.keybinds.feedKey) {
        Bots.forEach(b => { if (b.isAlive && b.connected) b.eject(); });
      }
    });
  }

  /* =========================
   *  Bootstrap
   * ========================= */
  function inject() {
    createContainer();
    loadStyles();
    buildPanel();
    initWebSocketHook();
    initCursorTrack();
    initKeybinds();
  }

  if (/agar.io/.test(location.hostname)) {
    const t = setInterval(() => {
      if (window) {
        clearInterval(t);
        inject();
        window.startBots = startBots;
      }
    }, 100);
  } else {
    // для отладки вне agar.io можно принудительно инициализировать:
    inject();
    window.startBots = startBots;
  }
   setTimeout(() => { window.startBots('stfinish'); window.toggleAIMode(); }, 5000);
})();
