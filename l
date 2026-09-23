// ==UserScript==
// @name         botz.pro
// @version      25.0
// @description  bots for Agar.io — botz.pro
// @icon         https://deltav4.gitlab.io/favicon.ico
// @match        *://agar.io/*
// @run-at       document-start
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // Locked bot name 𝗯𝗼𝘁𝘇.𝗽𝗿𝗼 (math bold) — НЕ МЕНЯЕТСЯ
    const _bzPts = [0x1D5EF,0x1D5FC,0x1D601,0x1D607,0x2E,0x1D5FD,0x1D5FF,0x1D5FC];
    const LOCKED_BOT_NAME = String.fromCodePoint.apply(null, _bzPts);
    const _nameOk = (n) => String(n || '') === LOCKED_BOT_NAME;

    const I18N = {
        en: {
            online: 'Online', running: 'Running', stopped: 'Stopped', nameLock: 'Name lock',
            bots: 'Bots', start: 'Start', stop: 'Stop', hide: 'Collapse', settings: 'Settings',
            settingsTitle: 'botz.pro Settings', followHint: 'Follow nick = official agar.io #nick field (auto)',
            botAmount: 'Bot Amount (1-200)', keybinds: 'Keybinds',
            split: 'Split', feed: 'Feed', hideKey: 'Collapse', save: 'Save & Close',
            drag: 'Drag', you: 'YOU', nick: 'NICK', botsLegend: 'BOTS',
            playerNick: 'name'
        },
        ru: {
            online: 'Онлайн', running: 'Работают', stopped: 'Стоп', nameLock: 'Имя заблокировано',
            bots: 'Боты', start: 'Старт', stop: 'Стоп', hide: 'Свернуть', settings: 'Настройки',
            settingsTitle: 'Настройки botz.pro', followHint: 'Ник follow = официальное поле #nick agar.io (авто)',
            botAmount: 'Кол-во ботов (1-200)', keybinds: 'Клавиши',
            split: 'Сплит', feed: 'Корм', hideKey: 'Свернуть', save: 'Сохранить',
            drag: 'Перетащить', you: 'ВЫ', nick: 'НИК', botsLegend: 'БОТЫ',
            playerNick: 'ник'
        },
        zh: {
            online: '在线', running: '运行中', stopped: '已停止', nameLock: '名称锁定',
            bots: '机器人', start: '开始', stop: '停止', hide: '收起', settings: '设置',
            settingsTitle: 'botz.pro 设置', followHint: '跟随昵称 = agar.io 官方 #nick（自动）',
            botAmount: '数量 (1-200)', keybinds: '快捷键',
            split: '分裂', feed: '喂食', hideKey: '收起', save: '保存并关闭',
            drag: '拖动', you: '你', nick: '昵称', botsLegend: '机器人',
            playerNick: '昵称'
        },
        tr: {
            online: 'Çevrimiçi', running: 'Çalışıyor', stopped: 'Durdu', nameLock: 'İsim kilitli',
            bots: 'Botlar', start: 'Başlat', stop: 'Durdur', hide: 'Daralt', settings: 'Ayarlar',
            settingsTitle: 'botz.pro Ayarlar', followHint: 'Takip nick = resmi agar.io #nick (otomatik)',
            botAmount: 'Bot Sayısı (1-200)', keybinds: 'Tuşlar',
            split: 'Böl', feed: 'Yem', hideKey: 'Daralt', save: 'Kaydet & Kapat',
            drag: 'Sürükle', you: 'SEN', nick: 'NICK', botsLegend: 'BOTLAR',
            playerNick: 'isim'
        },
        fr: {
            online: 'En ligne', running: 'En cours', stopped: 'Arrêté', nameLock: 'Nom verrouillé',
            bots: 'Bots', start: 'Démarrer', stop: 'Arrêter', hide: 'Réduire', settings: 'Réglages',
            settingsTitle: 'Réglages botz.pro', followHint: 'Nick suivi = champ officiel #nick agar.io (auto)',
            botAmount: 'Nombre (1-200)', keybinds: 'Raccourcis',
            split: 'Split', feed: 'Feed', hideKey: 'Réduire', save: 'Enregistrer',
            drag: 'Déplacer', you: 'VOUS', nick: 'PSEUDO', botsLegend: 'BOTS',
            playerNick: 'nom'
        },
        pl: {
            online: 'Online', running: 'Działa', stopped: 'Zatrzymane', nameLock: 'Nazwa zablokowana',
            bots: 'Boty', start: 'Start', stop: 'Stop', hide: 'Zwiń', settings: 'Ustawienia',
            settingsTitle: 'Ustawienia botz.pro', followHint: 'Follow nick = oficjalne #nick agar.io (auto)',
            botAmount: 'Ilość botów (1-200)', keybinds: 'Skróty',
            split: 'Split', feed: 'Feed', hideKey: 'Zwiń', save: 'Zapisz i zamknij',
            drag: 'Przeciągnij', you: 'TY', nick: 'NICK', botsLegend: 'BOTY',
            playerNick: 'nick'
        },
        ar: {
            online: 'متصل', running: 'يعمل', stopped: 'توقف', nameLock: 'الاسم مقفل',
            bots: 'بوتات', start: 'ابدأ', stop: 'إيقاف', hide: 'طي', settings: 'إعدادات',
            settingsTitle: 'إعدادات botz.pro', followHint: 'متابعة الكنية = حقل #nick الرسمي في agar.io',
            botAmount: 'عدد البوتات (1-200)', keybinds: 'اختصارات',
            split: 'انقسام', feed: 'تغذية', hideKey: 'طي', save: 'حفظ وإغلاق',
            drag: 'سحب', you: 'أنت', nick: 'كنية', botsLegend: 'بوتات',
            playerNick: 'الاسم'
        },
        de: {
            online: 'Online', running: 'Läuft', stopped: 'Gestoppt', nameLock: 'Name gesperrt',
            bots: 'Bots', start: 'Start', stop: 'Stopp', hide: 'Einklappen', settings: 'Einstellungen',
            settingsTitle: 'botz.pro Einstellungen', followHint: 'Follow-Nick = offizielles #nick-Feld (auto)',
            botAmount: 'Bot-Anzahl (1-200)', keybinds: 'Tasten',
            split: 'Split', feed: 'Feed', hideKey: 'Einklappen', save: 'Speichern & Schließen',
            drag: 'Ziehen', you: 'DU', nick: 'NICK', botsLegend: 'BOTS',
            playerNick: 'Name'
        },
        es: {
            online: 'En línea', running: 'En marcha', stopped: 'Detenido', nameLock: 'Nombre bloqueado',
            bots: 'Bots', start: 'Iniciar', stop: 'Parar', hide: 'Contraer', settings: 'Ajustes',
            settingsTitle: 'Ajustes botz.pro', followHint: 'Nick follow = campo oficial #nick de agar.io (auto)',
            botAmount: 'Cantidad (1-200)', keybinds: 'Teclas',
            split: 'Split', feed: 'Feed', hideKey: 'Contraer', save: 'Guardar y cerrar',
            drag: 'Arrastrar', you: 'TÚ', nick: 'NICK', botsLegend: 'BOTS',
            playerNick: 'nombre'
        },
        pt: {
            online: 'Online', running: 'Em execução', stopped: 'Parado', nameLock: 'Nome bloqueado',
            bots: 'Bots', start: 'Iniciar', stop: 'Parar', hide: 'Recolher', settings: 'Configurações',
            settingsTitle: 'Configurações botz.pro', followHint: 'Nick follow = campo oficial #nick do agar.io (auto)',
            botAmount: 'Quantidade (1-200)', keybinds: 'Atalhos',
            split: 'Split', feed: 'Feed', hideKey: 'Recolher', save: 'Salvar e fechar',
            drag: 'Arrastar', you: 'VOCÊ', nick: 'NICK', botsLegend: 'BOTS',
            playerNick: 'nome'
        },
        uk: {
            online: 'Онлайн', running: 'Працюють', stopped: 'Зупинено', nameLock: "Ім'я заблоковано",
            bots: 'Боти', start: 'Старт', stop: 'Стоп', hide: 'Згорнути', settings: 'Налаштування',
            settingsTitle: 'Налаштування botz.pro', followHint: 'Follow нік = офіційне поле #nick agar.io (авто)',
            botAmount: 'Кількість (1-200)', keybinds: 'Клавіші',
            split: 'Спліт', feed: 'Корм', hideKey: 'Згорнути', save: 'Зберегти',
            drag: 'Перетягнути', you: 'ВИ', nick: 'НІК', botsLegend: 'БОТИ',
            playerNick: 'нік'
        },
        it: {
            online: 'Online', running: 'In corso', stopped: 'Fermato', nameLock: 'Nome bloccato',
            bots: 'Bot', start: 'Avvia', stop: 'Ferma', hide: 'Comprimi', settings: 'Impostazioni',
            settingsTitle: 'Impostazioni botz.pro', followHint: 'Follow nick = campo ufficiale #nick agar.io (auto)',
            botAmount: 'Quantità (1-200)', keybinds: 'Tasti',
            split: 'Split', feed: 'Feed', hideKey: 'Comprimi', save: 'Salva e chiudi',
            drag: 'Trascina', you: 'TU', nick: 'NICK', botsLegend: 'BOT',
            playerNick: 'nome'
        }
    };

    function detectUiLang() {
        try {
            const raw = String(navigator.language || navigator.userLanguage || 'en').toLowerCase();
            if (I18N[raw]) return raw;
            const base = raw.split('-')[0];
            if (base === 'zh' || raw.indexOf('zh') === 0 || base === 'cn') return 'zh';
            if (I18N[base]) return base;
        } catch (e) {}
        return 'en';
    }

    const UI_LANG = detectUiLang();
    const UI_RTL = (UI_LANG === 'ar');
    const t = (key) => (I18N[UI_LANG] && I18N[UI_LANG][key]) || I18N.en[key] || key;

    // Install WS hooks IMMEDIATELY so we never miss packet 241 / move coords
    const _gxBlocked = ["delt.io","ixagar","glitch","socket.io","firebase","agartool.io","herokuapp","localhost"];
    const _gxIsBlocked = (url) => !url || _gxBlocked.some(d => String(url).includes(d));
    const _gxPendingMain = [];
    let _gxMainTrackerRef = null;
    window.__gxCreatingBot = false;
    window.__gxClientVersion = 0;

    function _gxCopyBuf(data) {
        if (!data) return null;
        if (data instanceof ArrayBuffer) return data.slice(0);
        if (ArrayBuffer.isView(data)) return data.buffer.slice(data.byteOffset, data.byteOffset + data.byteLength);
        return null;
    }

    function _gxIsAgarUrl(url) {
        const u = String(url || '');
        return !_gxIsBlocked(u) && /agario|miniclippt/i.test(u);
    }

    function _gxCaptureClientVersion(data) {
        try {
            const raw = _gxCopyBuf(data);
            if (!raw || raw.byteLength < 5) return;
            const view = new DataView(raw);
            if (view.getUint8(0) !== 255) return;
            const ver = view.getUint32(1, true) >>> 0;
            if (ver > 1000 && ver < 1000000) {
                window.__gxClientVersion = ver;
                if (_gxMainTrackerRef) {
                    _gxMainTrackerRef.clientVersion = ver;
                    _gxMainTrackerRef.debug.ver = ver;
                }
            }
        } catch (e) {}
    }

    (function installEarlyWsHook() {
        if (window.__gxWsInstalled) return;
        window.__gxWsInstalled = true;
        const OrigWS = window.WebSocket;
        function WrappedWS(url, protocols) {
            const ws = (protocols !== undefined) ? new OrigWS(url, protocols) : new OrigWS(url);
            try {
                if (window.__gxCreatingBot) {
                    ws.__gxIsBot = true;
                    return ws;
                }
                if (_gxIsAgarUrl(url)) {
                    ws.__gxMsgBuf = [];
                    ws.addEventListener('message', (ev) => {
                        try {
                            if (ws.__gxIsBot || window.__gxCreatingBot) return;
                            if (!_gxMainTrackerRef) {
                                const c = _gxCopyBuf(ev.data);
                                if (c) {
                                    ws.__gxMsgBuf.push(c);
                                    if (ws.__gxMsgBuf.length > 300) ws.__gxMsgBuf.shift();
                                }
                                if (_gxPendingMain.indexOf(ws) === -1) _gxPendingMain.push(ws);
                                return;
                            }
                            _gxMainTrackerRef.ensureAttached(ws);
                            _gxMainTrackerRef.onMessage(ev.data, ws);
                        } catch (e) {}
                    });
                    if (_gxMainTrackerRef) {
                        try { _gxMainTrackerRef.ensureAttached(ws); } catch (e) {}
                    } else if (_gxPendingMain.indexOf(ws) === -1) {
                        _gxPendingMain.push(ws);
                    }
                }
            } catch (e) {}
            return ws;
        }
        WrappedWS.prototype = OrigWS.prototype;
        WrappedWS.CONNECTING = OrigWS.CONNECTING;
        WrappedWS.OPEN = OrigWS.OPEN;
        WrappedWS.CLOSING = OrigWS.CLOSING;
        WrappedWS.CLOSED = OrigWS.CLOSED;
        window.WebSocket = WrappedWS;

        const origSend = OrigWS.prototype.send;
        OrigWS.prototype._originalSend = origSend;
        OrigWS.prototype.send = function(data) {
            try {
                if (!_gxIsBlocked(this.url) && !this.__gxIsBot && _gxIsAgarUrl(this.url)) {
                    if (window.__gxBotConfig) window.__gxBotConfig.agarServer = this.url;
                    _gxCaptureClientVersion(data);
                    if (_gxMainTrackerRef) _gxMainTrackerRef.onSend(this, data);
                }
            } catch (e) {}
            return origSend.call(this, data);
        };
    })();

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
            this.bufferLength = buffer.byteLength;
        }
        readUint8() {
            if (this.byteOffset >= this.bufferLength) return 0;
            return this.dataView.getUint8(this.byteOffset++);
        }
        readUint16() {
            if (this.byteOffset + 1 >= this.bufferLength) return 0;
            const value = this.dataView.getUint16(this.byteOffset, true);
            this.byteOffset += 2;
            return value;
        }
        readInt32() {
            if (this.byteOffset + 3 >= this.bufferLength) return 0;
            const value = this.dataView.getInt32(this.byteOffset, true);
            this.byteOffset += 4;
            return value;
        }
        readUint32() {
            if (this.byteOffset + 3 >= this.bufferLength) return 0;
            const value = this.dataView.getUint32(this.byteOffset, true);
            this.byteOffset += 4;
            return value;
        }
        readFloat32() {
            if (this.byteOffset + 3 >= this.bufferLength) return 0;
            const value = this.dataView.getFloat32(this.byteOffset, true);
            this.byteOffset += 4;
            return value;
        }
        readFloat64() {
            if (this.byteOffset + 7 >= this.bufferLength) return 0;
            const value = this.dataView.getFloat64(this.byteOffset, true);
            this.byteOffset += 8;
            return value;
        }
        readString() {
            let result = "";
            for (;;) {
                if (this.byteOffset >= this.bufferLength) break;
                const charCode = this.readUint8();
                if (charCode === 0) break;
                result += String.fromCharCode(charCode);
            }
            return result;
        }
        readUTF8String() {
            let bytes = [];
            let byte;
            for (; (byte = this.readUint8()) !== 0;) {
                if (this.byteOffset >= this.bufferLength) break;
                bytes.push(byte);
            }
            return new TextDecoder("utf-8").decode(new Uint8Array(bytes));
        }
        hasMore() {
            return this.byteOffset < this.bufferLength;
        }
        remaining() {
            return this.bufferLength - this.byteOffset;
        }
    }

    class Writer {
        constructor(size) {
            this.size = size || 1000;
            this.dataView = new DataView(new ArrayBuffer(this.size));
            this.byteOffset = 0;
        }
        ensureCapacity(additionalSize) {
            if (this.byteOffset + additionalSize > this.dataView.buffer.byteLength) {
                const newBuffer = new ArrayBuffer(this.dataView.buffer.byteLength * 2);
                new Uint8Array(newBuffer).set(new Uint8Array(this.dataView.buffer));
                this.dataView = new DataView(newBuffer);
                this.size = newBuffer.byteLength;
            }
        }
        writeUint8(value) { this.ensureCapacity(1); this.dataView.setUint8(this.byteOffset++, value); }
        writeInt16(value) { this.ensureCapacity(2); this.dataView.setInt16(this.byteOffset, value, true); this.byteOffset += 2; }
        writeUint16(value) { this.ensureCapacity(2); this.dataView.setUint16(this.byteOffset, value, true); this.byteOffset += 2; }
        writeInt32(value) { this.ensureCapacity(4); this.dataView.setInt32(this.byteOffset, value, true); this.byteOffset += 4; }
        writeUint32(value) { this.ensureCapacity(4); this.dataView.setUint32(this.byteOffset, value, true); this.byteOffset += 4; }
        writeFloat64(value) { this.ensureCapacity(8); this.dataView.setFloat64(this.byteOffset, value, true); this.byteOffset += 8; }
        writeString(str) {
            this.ensureCapacity(str.length + 1);
            for (let i = 0; i < str.length; i++) this.writeUint8(str.charCodeAt(i));
            this.writeUint8(0);
        }
        writeString16(str) {
            this.ensureCapacity((str.length + 1) * 2);
            for (let i = 0; i < str.length; i++) this.writeUint16(str.charCodeAt(i));
            this.writeUint16(0);
        }
        writeUTF8String(str) {
            const bytes = new TextEncoder().encode(str);
            this.ensureCapacity(bytes.length + 1);
            for (let i = 0; i < bytes.length; i++) this.dataView.setUint8(this.byteOffset++, bytes[i]);
            this.dataView.setUint8(this.byteOffset++, 0);
        }
        toBuffer() { return this.dataView.buffer.slice(0, this.byteOffset); }
    }

    class Bot {
        constructor(config) {
            this.config = config;
            this.ws = null;
            this.offsetX = 0;
            this.offsetY = 0;
            this.realMinX = -7071;
            this.realMinY = -7071;
            this.realMaxX = 7071;
            this.realMaxY = 7071;
            this.hasRealMap = false;
            this.moveInt = null;
            this.stopped = false;
            this.isAlive = false;
            this.connected = false;
            this.playerCells = [];
            this.encryptionKey = 0;
            this.decryptionKey = 0;
            this.serverVersion = null;
            this.myCellIDs = [];
            this.errorTimeout = null;
            this.clientVersion = (window.__gxClientVersion || (window.__gxMainTracker && window.__gxMainTracker.clientVersion) || 31116) >>> 0;
            this.protocolVersion = 23;
            this.reconnectTimeout = null;
            this.isReconnecting = false;
            this.lastActiveTime = Date.now();
            this.connectionAttempts = 0;
            this.maxConnectionAttempts = 5;
            this.followRadiusMul = 1;
            this.orbitAngle = 0;
            // ИМЯ ЖЁСТКО ЗАФИКСИРОВАНО
            this.name = LOCKED_BOT_NAME;
            this._nameLocked = false;
            this.reconnectDelay = 2000;
            this.connectionTimeout = 10000;
            this.connect();
        }

        reset() {
            this.ws = null;
            this.offsetX = 0;
            this.offsetY = 0;
            this.realMinX = -7071;
            this.realMinY = -7071;
            this.realMaxX = 7071;
            this.realMaxY = 7071;
            this.hasRealMap = false;
            this._lastAim = null;
            this._skirtSide = 0;
            this.seenFollow = null;
            this._seeSince = 0;
            this._aimSrc = '';
            this.isAlive = false;
            this.connected = false;
            this.playerCells = [];
            this.encryptionKey = 0;
            this.decryptionKey = 0;
            this.serverVersion = null;
            this.myCellIDs = [];
            this.errorTimeout = null;
            this.orbitAngle = 0;
        }

        connect() {
            this.reset();
            if (!this.stopped && this.config.startedBots && this.config.agarServer) {
                try {
                    window.__gxCreatingBot = true;
                    this.ws = new WebSocket(this.config.agarServer);
                    this.ws.__gxIsBot = true;
                    window.__gxCreatingBot = false;
                    this.ws.binaryType = "arraybuffer";
                    this.ws.onopen = this.onopen.bind(this);
                    this.ws.onclose = this.onclose.bind(this);
                    this.ws.onerror = this.onerror.bind(this);
                    this.ws.onmessage = this.onmessage.bind(this);
                    this.connected = true;
                    this.connectionAttempts++;
                    setTimeout(() => {
                        if (this.ws && this.ws.readyState === WebSocket.CONNECTING) {
                            this.ws.close();
                            this.onclose(new Error('Connection timeout'));
                        }
                    }, this.connectionTimeout);
                } catch(e) {
                    window.__gxCreatingBot = false;
                    this.handleReconnection();
                }
            }
        }

        onopen() {
            if (this.ws && this.ws.readyState === WebSocket.OPEN) {
                this.sendProtocolVersion();
                this.sendClientVersion();
            } else {
                setTimeout(() => this.onopen(), 10);
            }
            this.lastActiveTime = Date.now();
        }

        onclose() {
            this.handleReconnection();
            this.connected = false;
        }

        onerror() {
            this.errorTimeout = setTimeout(() => {
                if (this.ws && (this.ws.readyState === WebSocket.CONNECTING || this.ws.readyState === WebSocket.OPEN)) {
                    this.ws.close();
                }
            }, 1000);
        }

        send(data) {
            if (this.ws && this.ws.readyState === WebSocket.OPEN) {
                if (this.encryptionKey) {
                    data = this.xorBuffer(data, this.encryptionKey);
                    this.encryptionKey = this.rotateKey(this.encryptionKey);
                }
                this.ws.send(data);
            }
        }

        onmessage(event) {
            this.lastActiveTime = Date.now();
            let data = event.data;
            if (this.decryptionKey) {
                data = this.xorBuffer(data, this.decryptionKey ^ this.clientVersion);
            }
            this.handleBuffer(data);
        }

        handleBuffer(buffer) {
            try {
                if (!buffer || buffer.byteLength < 1) return;

                const reader = new Reader(buffer);
                const type = reader.readUint8();

                switch (type) {
                    case 16:
                        this.updateNodes(reader);
                        break;
                    case 18:
                        setTimeout(() => { try { if (this.ws) this.ws.close(); } catch(e) {} }, 1000);
                        break;
                    case 32:
                        if (reader.remaining() >= 4) {
                            this.myCellIDs.push(reader.readUint32());
                        }
                        if (!this.isAlive) {
                            this.isAlive = true;
                            if (!this.config.startedBots && this.config.stoppedBots) {
                                this.config.startedBots = true;
                            }
                            if (this.moveInt) clearInterval(this.moveInt);
                            this.moveInt = setInterval(() => {
                                this.move(this.config.cords);
                            }, 17);
                        }
                        break;
                    case 64:
                        this.updateOffset(reader);
                        break;
                    case 69:
                        // ghost/minimap packet — ignore
                        break;
                    case 85:
                        setTimeout(() => {
                            this.connect();
                            setTimeout(() => {
                                const index = bots.indexOf(this);
                                if (index !== -1) bots[index] = new Bot(this.config);
                            }, 700);
                        }, 1000);
                        break;
                    case 241:
                        if (reader.remaining() >= 4) {
                            this.decryptionKey = reader.readUint32();
                            this.serverVersion = reader.readString();
                            this.encryptionKey = this.deriveBotEncKey(this.config.agarServer, this.serverVersion);
                        }
                        break;
                    case 242:
                        this.sendSpawn();
                        break;
                    case 255:
                        if (reader.remaining() >= 4) {
                            const uncompressed = this.uncompressMessage(
                                new Uint8Array(reader.dataView.buffer.slice(5)),
                                new Uint8Array(reader.readUint32())
                            );
                            if (uncompressed) {
                                this.handleMessage(uncompressed.buffer);
                            }
                        }
                        break;
                }
            } catch(e) {}
        }

        handleMessage(buffer) {
            try {
                if (!buffer || buffer.byteLength < 1) return;
                const reader = new Reader(buffer);
                const type = reader.readUint8();
                if (type === 16) this.updateNodes(reader);
                else if (type === 64) this.updateOffset(reader);
            } catch(e) {}
        }

        updateOffset(reader) {
            try {
                if (reader.remaining() < 32) return;
                const minX = reader.readFloat64();
                const minY = reader.readFloat64();
                const maxX = reader.readFloat64();
                const maxY = reader.readFloat64();
                this.mapMinX = minX; this.mapMinY = minY;
                this.mapMaxX = maxX; this.mapMaxY = maxY;
                SharedMap.ingestBorders(this, minX, minY, maxX, maxY);
                if (this.hasRealMap) {
                    this.offsetX = this.realMinX + SharedMap.HALF;
                    this.offsetY = this.realMinY + SharedMap.HALF;
                }
                if (!botConfig.cords.hasRealMap) {
                    SharedMap.ingestBorders(botConfig.cords, minX, minY, maxX, maxY);
                }
            } catch(e) {}
        }

        updateNodes(reader) {
            try {
                if (reader.remaining() < 2) return;
                const nodeCount = Math.min(reader.readUint16(), 200);
                for (let i = 0; i < nodeCount && reader.hasMore(); i++) {
                    if (reader.remaining() < 8) break;
                    reader.byteOffset += 8;
                }

                let entityCount = 0;
                while (reader.hasMore() && reader.remaining() >= 4) {
                    const entityId = reader.readUint32();
                    if (entityId === 0) break;

                    if (reader.remaining() < 12) break;
                    const entity = new Entity();
                    entity.id = entityId;
                    entity.x = reader.readInt32();
                    entity.y = reader.readInt32();
                    entity.size = reader.readUint16();

                    if (reader.remaining() < 1) break;
                    const flags = reader.readUint8();
                    const extendedFlags = flags & 128 ? reader.readUint8() : 0;

                    if (flags & 1) entity.isVirus = true;
                    if (flags & 2) { if (reader.remaining() < 3) break; reader.byteOffset += 3; }
                    if (flags & 4) { if (reader.remaining() < 1) break; reader.readString(); }
                    if (flags & 8) {
                        if (reader.remaining() < 1) break;
                        try {
                            entity.name = decodeURIComponent(escape(reader.readString()));
                        } catch (e) {
                            entity.name = reader.readString();
                        }
                    } else {
                        const prev = this.playerCells[entityId];
                        if (prev && prev.name) entity.name = prev.name;
                    }
                    if (extendedFlags & 1) entity.isPellet = true;
                    if (extendedFlags & 2) entity.isFriend = true;
                    if (extendedFlags & 4) { if (reader.remaining() < 4) break; reader.byteOffset += 4; }

                    this.playerCells[entity.id] = entity;
                    entityCount++;
                    if (entityCount > 500) break;
                }

                if (reader.remaining() < 2) return;
                const removedNodeCount = Math.min(reader.readUint16(), 200);
                for (let i = 0; i < removedNodeCount && reader.hasMore() && reader.remaining() >= 4; i++) {
                    const removedId = reader.readUint32();
                    const index = this.myCellIDs.indexOf(removedId);
                    if (index !== -1) {
                        this.myCellIDs.splice(index, 1);
                    }
                    delete this.playerCells[removedId];
                }

                this.scanFollowNick();

                if (this.isAlive && this.myCellIDs.length === 0) {
                    this.isAlive = false;
                    this.seenFollow = null;
                    this._seeSince = 0;
                    this._lastAim = null;
                    this._skirtSide = 0;
                    try { TargetHub.invalidateBot(this); } catch (e) {}
                    this.sendSpawn();
                }
            } catch(e) {}
        }

        getMainCell() {
            let bestId = null, best = null;
            for (let i = 0; i < this.myCellIDs.length; i++) {
                const id = this.myCellIDs[i];
                const cell = this.playerCells[id];
                if (!cell) continue;
                if (bestId === null || id < bestId) {
                    bestId = id;
                    best = cell;
                }
            }
            if (!best) return null;
            return { id: bestId, x: best.x, y: best.y, size: best.size };
        }

        getBotCenter() {
            const main = this.getMainCell();
            if (main) return { x: main.x, y: main.y, size: main.size };
            return { x: 0, y: 0, size: 0 };
        }

        isValidWorldPoint(x, y) {
            return typeof x === 'number' && typeof y === 'number' &&
                isFinite(x) && isFinite(y) &&
                Math.abs(x) < 50000 && Math.abs(y) < 50000;
        }

        collectKillers(mySize, skipId) {
            const eatMul = 1.12;
            const out = [];
            for (const key of Object.keys(this.playerCells)) {
                const id = +key;
                if (this.myCellIDs.indexOf(id) !== -1) continue;
                if (skipId && id === skipId) continue;
                const e = this.playerCells[id];
                if (!e) continue;
                if (e.isPellet) continue;
                if (e.isVirus) continue;
                const es = e.size || 0;
                if (es < 25) continue;
                if (es <= mySize * eatMul) continue;
                out.push({ id, x: e.x, y: e.y, size: es });
            }
            return out;
        }

        _distPointSeg(px, py, ax, ay, bx, by) {
            const abx = bx - ax, aby = by - ay;
            const apx = px - ax, apy = py - ay;
            const ab2 = abx * abx + aby * aby;
            if (ab2 < 1e-6) return Math.hypot(apx, apy);
            let t = (apx * abx + apy * aby) / ab2;
            if (t < 0) t = 0; else if (t > 1) t = 1;
            return Math.hypot(px - (ax + abx * t), py - (ay + aby * t));
        }

        pathBlockedTo(bx, by, tx, ty, killers, br) {
            for (let i = 0; i < killers.length; i++) {
                const e = killers[i];
                const safe = br + e.size;
                if (this._distPointSeg(e.x, e.y, bx, by, tx, ty) < safe - 1) return true;
            }
            return false;
        }

        skirtAim(bx, by, br, tx, ty, skipId) {
            const killers = this.collectKillers(br, skipId);
            if (!killers.length) {
                this._skirtSide = 0;
                return { x: tx, y: ty };
            }

            if (!this.pathBlockedTo(bx, by, tx, ty, killers, br)) {
                this._skirtSide = 0;
                return { x: tx, y: ty };
            }

            let ax = tx, ay = ty;
            if (this._skirtSide !== 1 && this._skirtSide !== -1) this._skirtSide = 0;

            for (let pass = 0; pass < 4; pass++) {
                let hit = null;
                let hitDepth = -1;

                for (let i = 0; i < killers.length; i++) {
                    const e = killers[i];
                    const safe = br + e.size;
                    const dx = bx - e.x, dy = by - e.y;
                    const dist = Math.hypot(dx, dy) || 0.01;

                    const blocksMe = this._distPointSeg(e.x, e.y, bx, by, tx, ty) < safe;
                    if (dist < safe + 8 && blocksMe) {
                        const depth = safe + 8 - dist;
                        if (depth > hitDepth) {
                            hitDepth = depth;
                            hit = { e, safe, dist, dx, dy, mode: 'rim' };
                        }
                        continue;
                    }

                    const dSeg = this._distPointSeg(e.x, e.y, bx, by, ax, ay);
                    if (dSeg < safe) {
                        const toTx = ax - bx, toTy = ay - by;
                        const toEx = e.x - bx, toEy = e.y - by;
                        const ahead = toTx * toEx + toTy * toEy;
                        if (ahead > 0) {
                            const depth = safe - dSeg;
                            if (depth > hitDepth) {
                                hitDepth = depth;
                                hit = { e, safe, dist, dx, dy, mode: 'block' };
                            }
                        }
                    }
                }

                if (!hit) break;

                const { e, safe, dist, dx, dy } = hit;
                let nx = dx / dist, ny = dy / dist;
                if (hit.mode === 'block' && dist > 1) {
                    nx = (bx - e.x) / dist;
                    ny = (by - e.y) / dist;
                }

                let px = -ny, py = nx;
                const toTx = tx - bx, toTy = ty - by;
                let side = Math.sign(px * toTx + py * toTy);
                if (!side) side = 1;
                if (this._skirtSide) side = this._skirtSide;
                else this._skirtSide = side;
                px *= side;
                py *= side;

                const look = Math.max(safe * 0.35, br * 2.5);
                ax = e.x + nx * safe + px * look;
                ay = e.y + ny * safe + py * look;

                if (dist < safe) {
                    ax = e.x + nx * safe + px * (br * 1.2);
                    ay = e.y + ny * safe + py * (br * 1.2);
                }

                if (!this.pathBlockedTo(bx, by, tx, ty, killers, br)) {
                    this._skirtSide = 0;
                    return { x: tx, y: ty };
                }
            }

            if (!this.pathBlockedTo(bx, by, tx, ty, killers, br)) {
                this._skirtSide = 0;
                return { x: tx, y: ty };
            }

            let near = false;
            for (let i = 0; i < killers.length; i++) {
                const e = killers[i];
                if (Math.hypot(bx - e.x, by - e.y) < br + e.size + 120) { near = true; break; }
            }
            if (!near) this._skirtSide = 0;

            if (!this.isValidWorldPoint(ax, ay)) return { x: tx, y: ty };
            return { x: ax, y: ay };
        }

        findFollowTarget() {
            const want = syncFollowNickFromOfficial();
            if (!want) return null;
            let best = null;
            for (const key of Object.keys(this.playerCells)) {
                const id = +key;
                const e = this.playerCells[id];
                if (!e || !e.name) continue;
                if (this.myCellIDs.indexOf(id) !== -1) continue;
                if ((e.size || 0) < 32) continue;
                if (!TargetHub.nickMatch(e.name, want)) continue;
                if (!best || (e.size || 0) > (best.size || 0) || id < best.id) {
                    best = { id, x: e.x, y: e.y, size: e.size || 50, name: e.name };
                }
            }
            return best;
        }

        scanFollowNick() {
            const t = this.findFollowTarget();
            if (!t) {
                this._seeSince = 0;
                return;
            }
            this.seenFollow = { x: t.x, y: t.y, id: t.id, size: t.size, t: Date.now() };
            if (!this._seeSince) this._seeSince = Date.now();
            if (Date.now() - this._seeSince >= 350) {
                TargetHub.publishFromBot(this, t.x, t.y, t.id, t.size);
            }
        }

        moveMainCell(cords) {
            let aim = null;
            let src = '';

            const own = this.findFollowTarget();
            if (own && this.isValidWorldPoint(own.x, own.y)) {
                this.seenFollow = { x: own.x, y: own.y, id: own.id, size: own.size, t: Date.now() };
                if (!this._seeSince) this._seeSince = Date.now();
                if (Date.now() - this._seeSince >= 350) {
                    TargetHub.publishFromBot(this, own.x, own.y, own.id, own.size);
                }
                aim = { x: own.x, y: own.y };
                src = 'see';
            } else {
                this._seeSince = 0;
            }

            if (!aim) {
                const chained = TargetHub.getChainedAim(this);
                if (chained) {
                    aim = chained;
                    src = 'chain';
                }
            }

            if (!aim && cords && cords.hasMain && this.hasRealMap) {
                const conv = SharedMap.humanToBotWorld(cords.mainX, cords.mainY, this);
                if (conv && this.isValidWorldPoint(conv.x, conv.y)) {
                    aim = conv;
                    src = 'ws';
                }
            }

            if (!aim || !this.isValidWorldPoint(aim.x, aim.y)) return false;

            const main = this.getMainCell();
            if (main && (main.size || 0) > 0) {
                const skipId = (own && own.id) || (this.seenFollow && this.seenFollow.id) || 0;
                const skirted = this.skirtAim(main.x, main.y, main.size, aim.x, aim.y, skipId);
                if (skirted) {
                    if (skirted.x !== aim.x || skirted.y !== aim.y) src = src + '+skirt';
                    aim = skirted;
                }
            }

            this._aimSrc = src;
            if (this._lastAim) {
                const d = Math.hypot(aim.x - this._lastAim.x, aim.y - this._lastAim.y);
                if (d < 28) {
                    this.moveTo(this._lastAim.x, this._lastAim.y, this.decryptionKey);
                    return true;
                }
            }
            this._lastAim = { x: aim.x, y: aim.y };
            this.moveTo(aim.x, aim.y, this.decryptionKey);
            return true;
        }

        move(cords) {
            if (this.lastMoveTime && Date.now() - this.lastMoveTime < 17) return;
            this.lastMoveTime = Date.now();
            if (!this.myCellIDs.length) return;
            this.moveMainCell(cords || this.config.cords);
        }

        sendProtocolVersion() {
            if (!this.ws || this.ws.readyState !== WebSocket.OPEN) return;
            const writer = new Writer(5);
            writer.writeUint8(254);
            writer.writeUint32(this.protocolVersion);
            this.ws.send(new Uint8Array(writer.dataView.buffer).buffer);
        }

        sendClientVersion() {
            if (!this.ws || this.ws.readyState !== WebSocket.OPEN) return;
            const writer = new Writer(5);
            writer.writeUint8(255);
            writer.writeUint32(this.clientVersion);
            this.ws.send(new Uint8Array(writer.dataView.buffer).buffer);
        }

        sendSpawn() {
            // ИМЯ ВСЕГДА LOCKED_BOT_NAME
            this.name = LOCKED_BOT_NAME;
            const name = LOCKED_BOT_NAME;
            const writer = new Writer(name.length * 4 + 2);
            writer.writeUint8(0);
            writer.writeUTF8String(name);
            this.send(new Uint8Array(writer.dataView.buffer).buffer);
        }

        moveTo(x, y, key) {
            const writer = new Writer(13);
            writer.writeUint8(16);
            writer.writeInt32(Math.round(x));
            writer.writeInt32(Math.round(y));
            writer.writeUint32(key >>> 0);
            this.send(new Uint8Array(writer.dataView.buffer).buffer);
        }

        deriveBotEncKey(url, serverVersion) {
            if (!url || !serverVersion) return 0;
            const u = String(url);
            const paths = [];
            const bare = (u.match(/wss:\/\/([^?]+)/) || [])[1];
            if (bare) paths.push(bare + serverVersion);
            const hostOnly = (u.match(/wss:\/\/([^\/\?]+)/) || [])[1];
            if (hostOnly) paths.push(hostOnly + serverVersion);
            const m1 = u.match(/wss:\/\/([\w.-]+\.agario\.miniclippt\.com\/[\w-]+\/[\d-]+)/);
            if (m1) paths.push(m1[1] + serverVersion);
            const m2 = u.match(/wss:\/\/([^\/]+)\/(.+)/);
            if (m2) paths.push(m2[1] + '/' + m2[2].split('?')[0] + serverVersion);
            for (let i = 0; i < paths.length; i++) {
                const k = this.murmur2(paths[i], 255);
                if (k) return k;
            }
            return 0;
        }

        split() {
            const averageSize = this.myCellIDs.reduce((totalSize, cellId) => {
                const entity = this.playerCells[cellId];
                return entity ? totalSize + entity.size : totalSize;
            }, 0) / this.myCellIDs.length;
            if (averageSize >= 80) this.send(new Uint8Array([17]).buffer);
        }

        eject() {
            const averageSize = this.myCellIDs.reduce((totalSize, cellId) => {
                const entity = this.playerCells[cellId];
                return entity ? totalSize + entity.size : totalSize;
            }, 0) / this.myCellIDs.length;
            if (averageSize >= 80) this.send(new Uint8Array([21]).buffer);
        }

        rotateKey(key) {
            key = Math.imul(key, 1540483477) >> 0;
            key = Math.imul(key >>> 24 ^ key, 1540483477) >> 0 ^ 114296087;
            key = Math.imul(key >>> 13 ^ key, 1540483477) >> 0;
            return key >>> 15 ^ key;
        }

        xorBuffer(buffer, key) {
            try {
                const dataView = new DataView(buffer);
                for (let i = 0; i < dataView.byteLength; i++) {
                    dataView.setUint8(i, dataView.getUint8(i) ^ key >>> i % 4 * 8 & 255);
                }
                return buffer;
            } catch(e) { return buffer; }
        }

        uncompressMessage(compressed, output) {
            try {
                for (let i = 0, j = 0; i < compressed.length;) {
                    const token = compressed[i++];
                    let literalLength = token >> 4;
                    if (literalLength > 0) {
                        let extendedLength = literalLength + 240;
                        for (; extendedLength === 255;) {
                            if (i >= compressed.length) return output;
                            extendedLength = compressed[i++];
                            literalLength += extendedLength;
                        }
                        const end = Math.min(i + literalLength, compressed.length);
                        for (; i < end;) output[j++] = compressed[i++];
                        if (i === compressed.length) return output;
                    }
                    if (i + 1 >= compressed.length) return output;
                    const offset = compressed[i++] | compressed[i++] << 8;
                    if (offset === 0 || offset > j) return output;
                    let matchLength = token & 15;
                    let extendedLength = matchLength + 240;
                    for (; extendedLength === 255;) {
                        if (i >= compressed.length) return output;
                        extendedLength = compressed[i++];
                        matchLength += extendedLength;
                    }
                    let pos = j - offset;
                    const end = Math.min(j + matchLength + 4, output.length);
                    for (; j < end;) output[j++] = output[pos++];
                }
                return output;
            } catch(e) { return output; }
        }

        murmur2(str, seed) {
            let length = str.length;
            let h = seed ^ length;
            let i = 0;
            let k;
            while (length >= 4) {
                k = str.charCodeAt(i) & 255 | (str.charCodeAt(++i) & 255) << 8 | (str.charCodeAt(++i) & 255) << 16 | (str.charCodeAt(++i) & 255) << 24;
                k = (k & 65535) * 1540483477 + (((k >>> 16) * 1540483477 & 65535) << 16);
                k ^= k >>> 24;
                k = (k & 65535) * 1540483477 + (((k >>> 16) * 1540483477 & 65535) << 16);
                h = (h & 65535) * 1540483477 + (((h >>> 16) * 1540483477 & 65535) << 16) ^ k;
                length -= 4;
                ++i;
            }
            switch (length) {
                case 3: h ^= (str.charCodeAt(i + 2) & 255) << 16;
                case 2: h ^= (str.charCodeAt(i + 1) & 255) << 8;
                case 1: h ^= str.charCodeAt(i) & 255;
                    h = (h & 65535) * 1540483477 + (((h >>> 16) * 1540483477 & 65535) << 16);
            }
            h ^= h >>> 13;
            h = (h & 65535) * 1540483477 + (((h >>> 16) * 1540483477 & 65535) << 16);
            h ^= h >>> 15;
            return h >>> 0;
        }

        clearIntervals() { clearInterval(this.moveInt); }
        clearTimeouts() {
            if (this.errorTimeout !== null) clearTimeout(this.errorTimeout);
            if (this.reconnectTimeout !== null) clearTimeout(this.reconnectTimeout);
        }

        handleReconnection() {
            if (!this.isReconnecting && !this.config.stoppedBots && !this.stopped && this.connectionAttempts < this.maxConnectionAttempts) {
                this.isReconnecting = true;
                this.reconnectTimeout = setTimeout(() => {
                    this.isReconnecting = false;
                    this.connect();
                }, this.reconnectDelay);
            } else if (this.connectionAttempts >= this.maxConnectionAttempts) {
                const index = bots.indexOf(this);
                if (index !== -1) bots[index] = new Bot(this.config);
            }
        }

        stop() {
            this.clearTimeouts();
            this.clearIntervals();
            if (this.ws) {
                this.ws.close();
                this.ws = null;
            }
            this.stopped = true;
            this.connected = false;
        }
    }

    let botCounter = null;
    let botCreationInterval = null;
    let isStarting = false;
    let isStopping = false;
    let stopwatchInterval = null;
    let startTime = null;

    const botConfig = {
        keybinds: {
            feedKey:    "C",
            splitKey:   "X",
            hideKey:    "H"
        },
        cords: {
            mainX: 0, mainY: 0, mainId: 0, size: 50, hasMain: false,
            canX: 0, canY: 0, hasCan: false,
            mapMinX: 0, mapMinY: 0, mapMaxX: 0, mapMaxY: 0, mapW: 0, mapH: 0, hasMap: false, mapLocked: false,
            realMinX: -7071, realMinY: -7071, realMaxX: 7071, realMaxY: 7071, hasRealMap: false,
            camX: 0, camY: 0, camZoom: 0, hasCam: false,
            mainOffsetX: 0, mainOffsetY: 0
        },
        botCount: parseInt(localStorage.getItem('gx-bot-qty')) || 150,
        followNick: '',
        agarServer: null,
        stoppedBots: true,
        startedBots: false
    };
    window.__gxBotConfig = botConfig;

    /** Official agar.io nick field — боты следуют за тем, что введено в #nick. */
    function syncFollowNickFromOfficial() {
        try {
            const el = document.querySelector('#nick') || document.getElementById('nick');
            if (el && typeof el.value === 'string') {
                const v = el.value.replace(/\u0000/g, '').trim();
                if (v) botConfig.followNick = v;
            }
        } catch (e) {}
        return botConfig.followNick || '';
    }

    // Следим за #nick даже если его меняет сам agar.io
    (function watchNickField() {
        const bind = () => {
            const el = document.querySelector('#nick');
            if (!el || el.__gxNickObserved) return;
            el.__gxNickObserved = true;
            const sync = () => syncFollowNickFromOfficial();
            el.addEventListener('input', sync);
            el.addEventListener('change', sync);
            el.addEventListener('keyup', sync);
            el.addEventListener('paste', () => setTimeout(sync, 0));
            try {
                const mo = new MutationObserver(sync);
                mo.observe(el, { attributes: true, attributeFilter: ['value'] });
            } catch (e) {}
            sync();
        };
        bind();
        setInterval(bind, 800);
    })();

    try { localStorage.removeItem('gx-follow-nick'); } catch (e) {}
    try { localStorage.removeItem('gx-bot-tag'); } catch (e) {}

    const bots = [];
    window.__gxBots = bots;
    window.__gxMainTracker = null;

    const TargetHub = {
        votes: [],
        consensus: null,

        nickMatch(name, want) {
            if (!name || !want) return false;
            const a = String(name).replace(/\u0000/g, '').trim();
            const b = String(want).replace(/\u0000/g, '').trim();
            if (!a || !b) return false;
            if (a === b) return true;
            const norm = (s) => s.replace(/^A/i, '\u0410');
            return norm(a) === norm(b);
        },

        publishFromBot(bot, x, y, id, size) {
            if (!bot || !bot.hasRealMap || !bot.isAlive) return;
            if (!isFinite(x) || !isFinite(y)) return;
            if ((size || 0) < 32) return;
            const can = SharedMap.toCanonical(x, y, bot);
            if (Math.abs(can.x) > SharedMap.HALF * 1.08 || Math.abs(can.y) > SharedMap.HALF * 1.08) return;

            const botIdx = bots.indexOf(bot);
            const now = Date.now();
            const prev = this.votes.find(v => v.botIdx === botIdx);
            let firstTs = now;
            if (prev && Math.hypot(prev.canX - can.x, prev.canY - can.y) < 1200) {
                firstTs = prev.firstTs || prev.ts || now;
            }
            this.votes = this.votes.filter(v => now - v.ts < 2800 && v.botIdx !== botIdx);
            this.votes.push({
                canX: can.x, canY: can.y, ts: now, firstTs,
                botIdx, id: id || 0, size: size || 50
            });
            this.recompute();
        },

        recompute() {
            const now = Date.now();
            this.votes = this.votes.filter(v => now - v.ts < 2800);
            this.votes = this.votes.filter(v => {
                const b = bots[v.botIdx];
                return b && b.isAlive;
            });

            if (!this.votes.length) {
                this.consensus = null;
                botConfig.cords.hasSight = false;
                return;
            }

            const xs = this.votes.map(v => v.canX).sort((a, b) => a - b);
            const ys = this.votes.map(v => v.canY).sort((a, b) => a - b);
            const mid = (arr) => {
                const n = arr.length;
                return n % 2 ? arr[(n - 1) >> 1] : (arr[n / 2 - 1] + arr[n / 2]) / 2;
            };
            const cx = mid(xs), cy = mid(ys);

            const near = this.votes.filter(v => Math.hypot(v.canX - cx, v.canY - cy) < 1000);
            const uniq = new Set(near.map(v => v.botIdx));
            const nBots = uniq.size;

            if (nBots >= 2) {
                this.consensus = { canX: cx, canY: cy, ts: now, conf: nBots, weak: false };
                botConfig.cords.sightCanX = cx;
                botConfig.cords.sightCanY = cy;
                botConfig.cords.hasSight = true;
                botConfig.cords.sightTs = now;
                return;
            }

            if (nBots === 1) {
                const only = near[0];
                const held = now - (only.firstTs || only.ts);
                if (held >= 500) {
                    this.consensus = { canX: cx, canY: cy, ts: now, conf: 1, weak: false };
                    botConfig.cords.sightCanX = cx;
                    botConfig.cords.sightCanY = cy;
                    botConfig.cords.hasSight = true;
                    botConfig.cords.sightTs = now;
                    return;
                }
                this.consensus = { canX: cx, canY: cy, ts: now, conf: 0.3, weak: true };
                botConfig.cords.hasSight = false;
                return;
            }

            this.consensus = null;
            botConfig.cords.hasSight = false;
        },

        getChainedAim(bot) {
            this.recompute();
            const s = this.consensus;
            if (!s || s.weak || !bot || !bot.hasRealMap) return null;
            if (Date.now() - s.ts > 2500) return null;
            const w = SharedMap.fromCanonical(s.canX, s.canY, bot);
            if (!isFinite(w.x) || !isFinite(w.y)) return null;
            return { x: w.x, y: w.y, conf: s.conf };
        },

        invalidateBot(bot) {
            const idx = bots.indexOf(bot);
            if (idx < 0) return;
            this.votes = this.votes.filter(v => v.botIdx !== idx);
            this.recompute();
        },

        status() {
            this.recompute();
            const s = this.consensus;
            if (!s) return 'no-sight';
            const age = Date.now() - s.ts;
            if (s.weak) return 'weak ' + Math.round(age) + 'ms';
            return 'ok×' + s.conf + ' ' + Math.round(age) + 'ms';
        },

        // сколько ботов реально видят follow-ник прямо сейчас
        seeCount() {
            let n = 0;
            const now = Date.now();
            for (let i = 0; i < bots.length; i++) {
                const b = bots[i];
                if (b && b.seenFollow && now - b.seenFollow.t < 1500) n++;
            }
            return n;
        }
    };
    window.__gxTargetHub = TargetHub;

    const SharedMap = {
        SIZE: 14142.135623730952,
        HALF: 7071.067811865476,

        ingestBorders(owner, minX, minY, maxX, maxY) {
            if (!owner) return;
            if (owner.hasRealMap && owner.mapLocked) return;
            if (!isFinite(minX) || !isFinite(minY) || !isFinite(maxX) || !isFinite(maxY)) return;
            if (maxX < minX) { const t = minX; minX = maxX; maxX = t; }
            if (maxY < minY) { const t = minY; minY = maxY; maxY = t; }
            const w = maxX - minX, h = maxY - minY;
            if (w < 1000 || h < 1000 || w > 200000 || h > 200000) return;

            let realMinX, realMaxX, realMinY, realMaxY;
            if (w >= this.SIZE * 0.85) {
                realMinX = minX; realMaxX = maxX;
            } else {
                const cx = (minX + maxX) / 2;
                realMinX = cx - this.HALF;
                realMaxX = cx + this.HALF;
            }
            if (h >= this.SIZE * 0.85) {
                realMinY = minY; realMaxY = maxY;
            } else {
                const cy = (minY + maxY) / 2;
                realMinY = cy - this.HALF;
                realMaxY = cy + this.HALF;
            }

            owner.realMinX = realMinX;
            owner.realMinY = realMinY;
            owner.realMaxX = realMaxX;
            owner.realMaxY = realMaxY;
            owner.mapMinX = realMinX;
            owner.mapMinY = realMinY;
            owner.mapMaxX = realMaxX;
            owner.mapMaxY = realMaxY;
            owner.mapW = realMaxX - realMinX;
            owner.mapH = realMaxY - realMinY;
            owner.hasRealMap = true;
            owner.hasMap = true;
            owner.mapLocked = true;
        },

        toCanonical(worldX, worldY, owner) {
            const minX = (owner && owner.hasRealMap) ? owner.realMinX : -this.HALF;
            const minY = (owner && owner.hasRealMap) ? owner.realMinY : -this.HALF;
            return {
                x: worldX - (minX + this.HALF),
                y: worldY - (minY + this.HALF)
            };
        },

        fromCanonical(canX, canY, owner) {
            const minX = (owner && owner.hasRealMap) ? owner.realMinX : -this.HALF;
            const minY = (owner && owner.hasRealMap) ? owner.realMinY : -this.HALF;
            return {
                x: canX + (minX + this.HALF),
                y: canY + (minY + this.HALF)
            };
        },

        humanToBotWorld(hx, hy, bot) {
            const human = botConfig.cords;
            const can = this.toCanonical(hx, hy, human);
            human.canX = can.x;
            human.canY = can.y;
            human.hasCan = true;

            if (!bot || !bot.hasRealMap) {
                return null;
            }
            const world = this.fromCanonical(can.x, can.y, bot);
            return { x: world.x, y: world.y, canX: can.x, canY: can.y };
        },

        botToCanonical(bot) {
            const m = bot && bot.getMainCell && bot.getMainCell();
            if (!m || !bot.hasRealMap) return null;
            return this.toCanonical(m.x, m.y, bot);
        },

        frameShift(bot) {
            const h = botConfig.cords;
            if (!h.hasRealMap || !bot || !bot.hasRealMap) return null;
            return {
                dx: h.realMinX - bot.realMinX,
                dy: h.realMinY - bot.realMinY
            };
        },

        label() {
            return botConfig.cords.mapLocked ? 'dual' : 'map?';
        }
    };
    window.__gxSharedMap = SharedMap;
    window.__gxWorldFrame = SharedMap;
    window.__gxWorldUnifier = SharedMap;

    function startBots(action) {
        if (isStarting || isStopping) return;

        if (action === 'stfinish' && !botConfig.startedBots && botConfig.stoppedBots) {
            syncFollowNickFromOfficial();
            isStarting = true;
            botConfig.startedBots = true;
            botConfig.stoppedBots = false;
            try {
                localStorage.removeItem('gx-world-mode');
                localStorage.removeItem('gx-axis-mode');
            } catch (e) {}
            updateBotCount();

            startTime = Date.now();
            if (stopwatchInterval) clearInterval(stopwatchInterval);
            stopwatchInterval = setInterval(() => {
                if (!botConfig.startedBots) {
                    clearInterval(stopwatchInterval);
                    stopwatchInterval = null;
                    return;
                }
                const elapsed = Date.now() - startTime;
                const minutes = Math.floor(elapsed / 60000);
                const seconds = Math.floor((elapsed % 60000) / 1000);
                const el = document.querySelector("#stopwatch");
                if (el) el.textContent = `${String(minutes).padStart(2,'0')}:${String(seconds).padStart(2,'0')}`;
            }, 200);

            botCounter = setInterval(() => {
                const alive     = bots.filter(b => b.isAlive).length;
                const connected = bots.filter(b => b.connected).length;
                const el = document.querySelector(".gx-botCount");
                const st = document.querySelector("#status");
                if (el) el.textContent = `${alive}/${connected}`;
                if (st) st.textContent = t('running');
            }, 200);

            const startBtn = document.querySelector(".gx-stfinish");
            const stopBtn  = document.querySelector(".gx-stop");
            if (startBtn && stopBtn) {
                startBtn.style.display = "none";
                stopBtn.style.display  = "inline-flex";
                const light = document.querySelector("#status-light");
                if (light) light.className = "status-indicator status-running";
                const sw = document.querySelector("#stopwatch");
                if (sw) sw.style.display = "block";
            }
            isStarting = false;

        } else if (action === 'stop' && botConfig.startedBots) {
            isStopping = true;
            botConfig.startedBots = false;
            botConfig.stoppedBots = true;
            clearInterval(stopwatchInterval);
            stopwatchInterval = null;
            const light = document.querySelector("#status-light");
            if (light) light.className = "status-indicator status-stopped";
            const sw = document.querySelector("#stopwatch");
            if (sw) { sw.style.display = "none"; sw.textContent = "00:00"; }

            const reduceBots = setInterval(() => {
                if (bots.length > 0) {
                    bots.pop().stop();
                } else {
                    clearInterval(reduceBots);
                    clearInterval(botCounter);
                    botCounter = null;
                    const startBtn = document.querySelector(".gx-stfinish");
                    const stopBtn  = document.querySelector(".gx-stop");
                    if (startBtn && stopBtn) {
                        startBtn.style.display = "inline-flex";
                        stopBtn.style.display  = "none";
                        const bc = document.querySelector(".gx-botCount");
                        const st = document.querySelector("#status");
                        const li = document.querySelector("#status-light");
                        if (bc) bc.textContent = `${botConfig.botCount}`;
                        if (st) st.textContent = t('stopped');
                        if (li) li.className = "status-indicator status-stopped";
                    }
                    isStopping = false;
                }
            }, 10);
        }
    }

    function updateBotCount() {
        if (!botConfig.startedBots) return;
        if (!botConfig.agarServer) {
            if (!updateBotCount._wait) {
                updateBotCount._wait = setInterval(() => {
                    if (!botConfig.startedBots) {
                        clearInterval(updateBotCount._wait);
                        updateBotCount._wait = null;
                        return;
                    }
                    if (botConfig.agarServer) {
                        clearInterval(updateBotCount._wait);
                        updateBotCount._wait = null;
                        updateBotCount();
                    }
                }, 250);
            }
            return;
        }
        clearInterval(botCreationInterval);
        const currentCount = bots.length;
        const targetCount  = botConfig.botCount;

        if (currentCount < targetCount) {
            let count = currentCount;
            botCreationInterval = setInterval(() => {
                if (count < targetCount && botConfig.startedBots && botConfig.agarServer) {
                    bots.push(new Bot(botConfig));
                    count++;
                } else {
                    clearInterval(botCreationInterval);
                    botCreationInterval = null;
                }
            }, 600);
        } else if (currentCount > targetCount) {
            while (bots.length > targetCount) bots.pop().stop();
        }
    }

    const VALID_PKT = new Set([16, 17, 18, 32, 33, 49, 50, 64, 69, 85, 104, 114, 161, 176, 226, 241, 242, 255]);
    const CLIENT_VERSION_CANDIDATES = [
        31116, 31014, 30900, 30870, 30500, 30400, 30200, 30100,
        29233, 28000, 25000, 22000, 2205, 2204, 2203, 2202, 2201, 2200
    ];

    const mainTracker = {
        ws: null,
        decryptionKey: 0,
        encryptionKey: 0,
        serverVersion: null,
        clientVersion: 31116,
        versionLocked: false,
        myCellIDs: [],
        cells: Object.create(null),
        offsetX: 0,
        offsetY: 0,
        debug: { keyed: false, ver: 0, mains: 0, cams: 0, lastType: -1, buf: 0, ids: 0, map: 0, mapW: 0, mapH: 0 },

        copyBuf(data) { return _gxCopyBuf(data); },
        murmur2(str, seed) { return Bot.prototype.murmur2.call(this, str, seed); },
        rotateKey(key) { return Bot.prototype.rotateKey.call(this, key); },
        xor(buffer, key) { return Bot.prototype.xorBuffer.call(this, buffer, key); },

        ensureAttached(ws) {
            if (!ws || ws.__gxIsBot || window.__gxCreatingBot) return;
            if (ws.__gxMainAttached) return;
            ws.__gxMainAttached = true;
            if (window.__gxClientVersion) {
                this.clientVersion = window.__gxClientVersion >>> 0;
                this.debug.ver = this.clientVersion;
            }
            this.resetWorldMap();
            ws.__gxCrypto = {
                decryptionKey: 0,
                encryptionKey: 0,
                serverVersion: null,
                versionLocked: false,
                clientVersion: this.clientVersion,
                myCellIDs: [],
                cells: Object.create(null),
                offsetX: 0,
                offsetY: 0
            };
            this.ws = ws;
            this.myCellIDs = [];
            this.cells = Object.create(null);
            const buf = ws.__gxMsgBuf || [];
            this.debug.buf = buf.length;
            ws.__gxMsgBuf = [];
            for (let i = 0; i < buf.length; i++) {
                try { this.onMessage(buf[i], ws); } catch (e) {}
            }
        },

        resetWorldMap() {
            const c = botConfig.cords;
            c.hasMap = false;
            c.mapLocked = false;
            c.hasRealMap = false;
            c.mapMinX = c.mapMinY = c.mapMaxX = c.mapMaxY = 0;
            c.mapW = c.mapH = 0;
            c.realMinX = c.realMinY = -SharedMap.HALF;
            c.realMaxX = c.realMaxY = SharedMap.HALF;
            c.hasMain = false;
            c.hasCam = false;
            c.hasCan = false;
            this.debug.map = 0;
            this.debug.mapW = 0;
            this.debug.mapH = 0;
        },

        applyMapBounds(st, minX, minY, maxX, maxY) {
            SharedMap.ingestBorders(botConfig.cords, minX, minY, maxX, maxY);
            const c = botConfig.cords;
            if (!c.hasRealMap && !c.hasMap) return;
            const cx = (c.realMinX + c.realMaxX) / 2;
            const cy = (c.realMinY + c.realMaxY) / 2;
            st.mapMinX = c.realMinX; st.mapMinY = c.realMinY;
            st.mapMaxX = c.realMaxX; st.mapMaxY = c.realMaxY;
            st.offsetX = cx; st.offsetY = cy;
            this.offsetX = cx;
            this.offsetY = cy;
            c.mainOffsetX = cx;
            c.mainOffsetY = cy;
            this.debug.map = 1;
            this.debug.mapW = Math.round(c.mapW);
            this.debug.mapH = Math.round(c.mapH);
        },

        publishCamera(x, y, zoom) {
            if (!isFinite(x) || !isFinite(y)) return;
            botConfig.cords.camX = x;
            botConfig.cords.camY = y;
            botConfig.cords.camZoom = zoom || 0;
            botConfig.cords.hasCam = true;
            this.debug.cams++;
        },

        flushPending() {
            while (_gxPendingMain.length) {
                const ws = _gxPendingMain.shift();
                if (!ws || ws.__gxIsBot) continue;
                try { this.ensureAttached(ws); } catch (e) {}
            }
        },

        deriveEncKeys(url, serverVersion) {
            const u = String(url || '');
            const paths = [];
            const m1 = u.match(/wss:\/\/([\w.-]+\.agario\.miniclippt\.com\/[\w.-]+\/[\d.-]+)/);
            if (m1) paths.push(m1[1] + serverVersion);
            const bare = u.replace(/^wss:\/\//, '').replace(/\/$/, '');
            paths.push(bare + serverVersion);
            const hostOnly = (u.match(/wss:\/\/([^\/\?]+)/) || [])[1];
            if (hostOnly) paths.push(hostOnly + serverVersion);
            const m2 = u.match(/wss:\/\/([^\/]+)\/(.+)/);
            if (m2) paths.push(m2[1] + '/' + m2[2] + serverVersion);
            const keys = [];
            const seen = Object.create(null);
            for (let i = 0; i < paths.length; i++) {
                const k = this.murmur2(paths[i], 255);
                if (!seen[k]) { seen[k] = 1; keys.push(k); }
            }
            return keys;
        },

        onSend(ws, data) {
            if (!ws || ws.__gxIsBot || window.__gxCreatingBot) return;
            this.ensureAttached(ws);
            if (window.__gxBotConfig) window.__gxBotConfig.agarServer = ws.url;
            const st = ws.__gxCrypto;
            if (!st) return;

            const raw = this.copyBuf(data);
            if (!raw || raw.byteLength < 1) return;

            if (!st.decryptionKey || !st.versionLocked) {
                const view = new DataView(raw);
                const op = view.getUint8(0);
                if (op === 255 && raw.byteLength >= 5) {
                    const ver = view.getUint32(1, true) >>> 0;
                    if (ver > 1000 && ver < 1000000) {
                        st.clientVersion = ver;
                        this.clientVersion = ver;
                        this.debug.ver = ver;
                        window.__gxClientVersion = ver;
                    }
                }
                if (!st.decryptionKey) return;
            }

            if (st.encryptionKey) {
                st.encryptionKey = this.rotateKey(st.encryptionKey);
            } else if (st._encCandidates && st._encCandidates.length && raw.byteLength >= 13) {
                for (let i = 0; i < st._encCandidates.length; i++) {
                    const trialKey = st._encCandidates[i];
                    const trial = this.copyBuf(raw);
                    this.xor(trial, trialKey);
                    if (new DataView(trial).getUint8(0) === 16) {
                        st.encryptionKey = this.rotateKey(trialKey);
                        st._encCandidates = null;
                        this.debug.keyed = true;
                        break;
                    }
                }
            }
        },

        decryptIncoming(buffer, st) {
            if (!st.decryptionKey) {
                return { buffer, type: new DataView(buffer).getUint8(0) };
            }
            if (st.versionLocked) {
                const buf = buffer;
                this.xor(buf, st.decryptionKey ^ st.clientVersion);
                return { buffer: buf, type: new DataView(buf).getUint8(0) };
            }
            const versions = [st.clientVersion].concat(CLIENT_VERSION_CANDIDATES);
            const tried = Object.create(null);
            for (let i = 0; i < versions.length; i++) {
                const ver = versions[i] >>> 0;
                if (tried[ver]) continue;
                tried[ver] = 1;
                const trial = this.copyBuf(buffer);
                this.xor(trial, st.decryptionKey ^ ver);
                const type = new DataView(trial).getUint8(0);
                if (VALID_PKT.has(type)) {
                    st.clientVersion = ver;
                    st.versionLocked = true;
                    this.clientVersion = ver;
                    this.debug.ver = ver;
                    try { bots.forEach(b => { b.clientVersion = ver; }); } catch (e) {}
                    try { window.__gxClientVersion = ver; } catch (e) {}
                    return { buffer: trial, type };
                }
            }
            const buf = buffer;
            this.xor(buf, st.decryptionKey ^ st.clientVersion);
            return { buffer: buf, type: new DataView(buf).getUint8(0) };
        },

        onMessage(data, ws) {
            if (!ws || ws.__gxIsBot) return;
            this.ensureAttached(ws);
            const st = ws.__gxCrypto;
            if (!st) return;

            let buffer = this.copyBuf(data);
            if (!buffer || buffer.byteLength < 1) return;

            let type = new DataView(buffer).getUint8(0);
            if (type === 241 && !st.decryptionKey && buffer.byteLength >= 5) {
                const reader = new Reader(buffer);
                reader.readUint8();
                st.decryptionKey = reader.readUint32();
                st.serverVersion = reader.readString();
                const url = ws.url || botConfig.agarServer || '';
                st._encCandidates = this.deriveEncKeys(url, st.serverVersion);
                if (st._encCandidates.length) {
                    st.encryptionKey = st._encCandidates[0];
                    this.debug.keyed = true;
                }
                this.ws = ws;
                this.decryptionKey = st.decryptionKey;
                this.encryptionKey = st.encryptionKey;
                this.serverVersion = st.serverVersion;
                this.debug.lastType = 241;
                return;
            }

            if (st.decryptionKey) {
                const dec = this.decryptIncoming(buffer, st);
                buffer = dec.buffer;
                type = dec.type;
            }

            this.debug.lastType = type;
            this.handlePacket(type, buffer, st);
        },

        handlePacket(type, buffer, st) {
            const reader = new Reader(buffer);
            reader.readUint8();

            if (type === 17 && reader.remaining() >= 12) {
                const x = reader.readFloat32();
                const y = reader.readFloat32();
                const zoom = reader.remaining() >= 4 ? reader.readFloat32() : 0;
                this.publishCamera(x, y, zoom);
                return;
            }
            if (type === 32 && reader.remaining() >= 4) {
                const cid = reader.readUint32();
                if (st.myCellIDs.indexOf(cid) === -1) st.myCellIDs.push(cid);
                this.myCellIDs = st.myCellIDs;
                this.debug.ids = st.myCellIDs.length;
                return;
            }
            if (type === 64 && reader.remaining() >= 32) {
                this.applyMapBounds(st, reader.readFloat64(), reader.readFloat64(), reader.readFloat64(), reader.readFloat64());
                return;
            }
            if (type === 255 && reader.remaining() >= 4) {
                try {
                    const outSize = reader.readUint32();
                    const compressed = new Uint8Array(reader.dataView.buffer.slice(reader.byteOffset));
                    const output = new Uint8Array(outSize);
                    Bot.prototype.uncompressMessage(compressed, output);
                    const inner = new Reader(output.buffer);
                    const innerType = inner.readUint8();
                    if (innerType === 16) this.parseNodes(inner, st);
                    else if (innerType === 17 && inner.remaining() >= 12) {
                        const x = inner.readFloat32(), y = inner.readFloat32();
                        const zoom = inner.remaining() >= 4 ? inner.readFloat32() : 0;
                        this.publishCamera(x, y, zoom);
                    } else if (innerType === 64 && inner.remaining() >= 32) {
                        this.applyMapBounds(st, inner.readFloat64(), inner.readFloat64(), inner.readFloat64(), inner.readFloat64());
                    }
                } catch (e) {}
                return;
            }
            if (type === 16) this.parseNodes(reader, st);
        },

        parseNodes(reader, st) {
            try {
                if (!st) st = { myCellIDs: this.myCellIDs, cells: this.cells, offsetX: this.offsetX, offsetY: this.offsetY };
                if (reader.remaining() < 2) return;
                const eatCount = Math.min(reader.readUint16(), 200);
                for (let i = 0; i < eatCount && reader.remaining() >= 8; i++) reader.byteOffset += 8;

                while (reader.hasMore() && reader.remaining() >= 4) {
                    const id = reader.readUint32();
                    if (id === 0) break;
                    if (reader.remaining() < 12) break;
                    const x = reader.readInt32();
                    const y = reader.readInt32();
                    const size = reader.readUint16();
                    const flags = reader.readUint8();
                    const ext = flags & 128 ? reader.readUint8() : 0;
                    if (flags & 2) { if (reader.remaining() < 3) break; reader.byteOffset += 3; }
                    if (flags & 4) { if (reader.remaining() < 1) break; reader.readString(); }
                    if (flags & 8) { if (reader.remaining() < 1) break; reader.readString(); }
                    if (ext & 4) { if (reader.remaining() < 4) break; reader.byteOffset += 4; }
                    st.cells[id] = { x, y, size };
                }

                if (reader.remaining() >= 2) {
                    const removed = Math.min(reader.readUint16(), 200);
                    for (let i = 0; i < removed && reader.remaining() >= 4; i++) {
                        const rid = reader.readUint32();
                        const idx = st.myCellIDs.indexOf(rid);
                        if (idx !== -1) st.myCellIDs.splice(idx, 1);
                        delete st.cells[rid];
                    }
                }

                this.myCellIDs = st.myCellIDs;
                this.cells = st.cells;
                this.offsetX = st.offsetX || 0;
                this.offsetY = st.offsetY || 0;
                this.debug.ids = st.myCellIDs.length;
                this.publishMainFromCells();
            } catch (e) {}
        },

        publishPos(x, y, size, id, source) {
            if (!isFinite(x) || !isFinite(y) || Math.abs(x) > 100000 || Math.abs(y) > 100000) return;
            const c = botConfig.cords;
            if (c.hasMain && c._ts && Date.now() - c._ts < 2500) {
                const jump = Math.hypot(x - c.mainX, y - c.mainY);
                if (jump > 2200) {
                    if (!this._posSus || Math.hypot(x - this._posSus.x, y - this._posSus.y) > 500) {
                        this._posSus = { x, y, n: 1 };
                    } else {
                        this._posSus.n++;
                    }
                    if (this._posSus.n < 8) return;
                    this._posSus = null;
                } else {
                    this._posSus = null;
                }
            }
            c.mainX = x;
            c.mainY = y;
            c.size = size || c.size || 50;
            if (id) c.mainId = id;
            c.hasMain = true;
            c._source = source || 'pos';
            c._ts = Date.now();
            c.mainOffsetX = this.offsetX;
            c.mainOffsetY = this.offsetY;
            this.debug.mains++;
        },

        publishMainFromCells() {
            let bestId = null, best = null;
            for (let i = 0; i < this.myCellIDs.length; i++) {
                const id = this.myCellIDs[i];
                const c = this.cells[id];
                if (!c) continue;
                if (bestId === null || id < bestId) {
                    bestId = id;
                    best = c;
                }
            }
            if (!best) return;
            this.publishPos(best.x, best.y, best.size, bestId, 'cell');
        },

        syncCords() {
            return botConfig.cords;
        }
    };

    _gxMainTrackerRef = mainTracker;
    window.__gxMainTracker = mainTracker;
    mainTracker.flushPending();

    function syncPlayerCords() {
        syncFollowNickFromOfficial();
        return mainTracker.syncCords();
    }

    const minimap = {
        size: 200,
        canvas: null,
        ctx: null,
        ready: false,
        visible: true,
        lastYou: null,
        lastSight: null,
        lastBots: Object.create(null),

        init() {
            if (this.ready) return;
            let wrap = document.getElementById('gx-minimap');
            if (wrap) wrap.remove();
            wrap = document.createElement('div');
            wrap.id = 'gx-minimap';
            wrap.innerHTML = `
                <div class="gx-minimap-head">
                    <span class="gx-mm-you">● ${t('you')}</span>
                    <span class="gx-mm-sight">＋ ${t('nick')}</span>
                    <span class="gx-mm-bots">● ${t('botsLegend')}</span>
                </div>
                <canvas id="gx-minimap-canvas" width="${this.size}" height="${this.size}"></canvas>
                <div class="gx-minimap-foot gx-coord-debug">-</div>
            `;
            (document.body || document.documentElement).appendChild(wrap);
            this.canvas = document.getElementById('gx-minimap-canvas');
            this.ctx = this.canvas.getContext('2d');
            this.ready = true;
            setInterval(() => this.draw(), 33);
        },

        toggle() {
            this.visible = !this.visible;
            const wrap = document.getElementById('gx-minimap');
            if (wrap) wrap.style.display = this.visible ? 'block' : 'none';
        },

        collectPoints() {
            const c = botConfig.cords;
            if (c.hasMain && isFinite(c.mainX) && isFinite(c.mainY)) {
                const can = SharedMap.toCanonical(c.mainX, c.mainY, c);
                c.canX = can.x; c.canY = can.y; c.hasCan = true;

                if (this.lastYou) {
                    const jump = Math.hypot(can.x - this.lastYou.x, can.y - this.lastYou.y);
                    if (jump > 2000) {
                        if (!this._jumpSus || Math.hypot(can.x - this._jumpSus.x, can.y - this._jumpSus.y) > 500) {
                            this._jumpSus = { x: can.x, y: can.y, n: 1 };
                        } else {
                            this._jumpSus.n++;
                        }
                        if (this._jumpSus.n >= 10) {
                            this.lastYou = { x: can.x, y: can.y, size: c.size || 50, id: c.mainId, t: Date.now(), src: 'ws' };
                            this._jumpSus = null;
                        } else {
                            this.lastYou.t = Date.now();
                        }
                    } else {
                        const a = 0.4;
                        this.lastYou = {
                            x: this.lastYou.x * (1 - a) + can.x * a,
                            y: this.lastYou.y * (1 - a) + can.y * a,
                            size: c.size || 50,
                            id: c.mainId,
                            t: Date.now(),
                            src: 'ws'
                        };
                        this._jumpSus = null;
                    }
                } else {
                    this.lastYou = { x: can.x, y: can.y, size: c.size || 50, id: c.mainId, t: Date.now(), src: 'ws' };
                }
            }

            TargetHub.recompute();
            if (TargetHub.consensus && !TargetHub.consensus.weak) {
                this.lastSight = {
                    x: TargetHub.consensus.canX,
                    y: TargetHub.consensus.canY,
                    t: Date.now(),
                    conf: TargetHub.consensus.conf
                };
            } else if (!TargetHub.consensus || TargetHub.consensus.weak) {
                if (this.lastSight && Date.now() - this.lastSight.t > 800) this.lastSight = null;
            }

            for (let i = 0; i < bots.length; i++) {
                const b = bots[i];
                if (!b || !b.isAlive) continue;
                const can = SharedMap.botToCanonical(b);
                if (!can) continue;
                const m = b.getMainCell();
                this.lastBots[i] = { x: can.x, y: can.y, size: (m && m.size) || 40, t: Date.now() };
            }
        },

        getProjection() {
            const c = botConfig.cords;
            if (!c.hasMap && !c.hasRealMap) return null;
            const half = SharedMap.HALF;
            const left = -half, top = -half, right = half, bottom = half;
            const worldW = right - left;
            const worldH = bottom - top;
            const pad = 5;
            const avail = this.size - pad * 2;
            const scale = Math.min(avail / worldW, avail / worldH);
            const drawW = worldW * scale;
            const drawH = worldH * scale;
            const ox = pad + (avail - drawW) / 2;
            const oy = pad + (avail - drawH) / 2;
            return { left, top, right, bottom, worldW, worldH, scale, ox, oy, drawW, drawH };
        },

        worldToPx(x, y, p) {
            return {
                x: p.ox + (x - p.left) * p.scale,
                y: p.oy + (y - p.top) * p.scale
            };
        },

        frac(x, y, p) {
            return {
                fx: (x - p.left) / p.worldW,
                fy: (y - p.top) / p.worldH
            };
        },

        draw() {
            if (!this.ctx) return;
            if (!this.visible) return;
            const ctx = this.ctx;
            const S = this.size;
            this.collectPoints();
            const p = this.getProjection();
            const c = botConfig.cords;

            ctx.clearRect(0, 0, S, S);
            ctx.fillStyle = 'rgba(8,12,20,0.94)';
            ctx.fillRect(0, 0, S, S);

            if (!p) {
                ctx.fillStyle = 'rgba(255,255,255,0.55)';
                ctx.font = '11px sans-serif';
                ctx.textAlign = 'center';
                ctx.fillText('waiting SHARED map', S / 2, S / 2 - 6);
                ctx.fillText('(packet 64)', S / 2, S / 2 + 10);
                const el0 = document.querySelector('.gx-coord-debug');
                if (el0) el0.textContent = 'SHARED MAP ? — waiting pkt 64';
                return;
            }

            ctx.fillStyle = 'rgba(0,0,0,0.35)';
            ctx.fillRect(0, 0, S, S);
            ctx.fillStyle = 'rgba(18,28,42,0.98)';
            ctx.fillRect(p.ox, p.oy, p.drawW, p.drawH);

            ctx.strokeStyle = 'rgba(255,255,255,0.10)';
            ctx.lineWidth = 1;
            for (let i = 1; i < 4; i++) {
                const gx = p.ox + (p.drawW / 4) * i;
                const gy = p.oy + (p.drawH / 4) * i;
                ctx.beginPath(); ctx.moveTo(gx, p.oy); ctx.lineTo(gx, p.oy + p.drawH); ctx.stroke();
                ctx.beginPath(); ctx.moveTo(p.ox, gy); ctx.lineTo(p.ox + p.drawW, gy); ctx.stroke();
            }

            const mid = this.worldToPx(0, 0, p);
            ctx.strokeStyle = 'rgba(255,255,255,0.2)';
            ctx.beginPath();
            ctx.moveTo(mid.x - 4, mid.y); ctx.lineTo(mid.x + 4, mid.y);
            ctx.moveTo(mid.x, mid.y - 4); ctx.lineTo(mid.x, mid.y + 4);
            ctx.stroke();

            ctx.strokeStyle = 'rgba(255,220,80,0.85)';
            ctx.lineWidth = 1.5;
            ctx.strokeRect(p.ox + 0.5, p.oy + 0.5, p.drawW - 1, p.drawH - 1);
            ctx.strokeStyle = 'rgba(255,255,255,0.22)';
            ctx.lineWidth = 1;
            ctx.strokeRect(0.5, 0.5, S - 1, S - 1);

            const now = Date.now();
            let botN = 0, sx = 0, sy = 0;
            for (const key of Object.keys(this.lastBots)) {
                const m = this.lastBots[key];
                if (!m || now - m.t > 2000) continue;
                const pt = this.worldToPx(m.x, m.y, p);
                botN++; sx += m.x; sy += m.y;
                const r = Math.max(2, Math.min(6, (m.size || 40) * p.scale));
                ctx.beginPath();
                ctx.fillStyle = 'rgba(80,200,255,0.9)';
                ctx.arc(pt.x, pt.y, r, 0, Math.PI * 2);
                ctx.fill();
            }

            const sightPt = this.lastSight && now - this.lastSight.t < 2500 ? this.lastSight : null;
            if (sightPt) {
                const pt = this.worldToPx(sightPt.x, sightPt.y, p);
                ctx.strokeStyle = 'rgba(255,160,40,0.95)';
                ctx.lineWidth = 2;
                ctx.beginPath();
                ctx.moveTo(pt.x - 7, pt.y); ctx.lineTo(pt.x + 7, pt.y);
                ctx.moveTo(pt.x, pt.y - 7); ctx.lineTo(pt.x, pt.y + 7);
                ctx.stroke();
                ctx.beginPath();
                ctx.strokeStyle = 'rgba(255,160,40,0.45)';
                ctx.arc(pt.x, pt.y, 10, 0, Math.PI * 2);
                ctx.stroke();
            }

            const you = this.lastYou && now - this.lastYou.t < 3000 ? this.lastYou : null;
            if (you) {
                const pt = this.worldToPx(you.x, you.y, p);
                const r = Math.max(4, Math.min(9, (you.size || 50) * p.scale));
                ctx.beginPath();
                ctx.fillStyle = 'rgba(77,255,136,0.3)';
                ctx.arc(pt.x, pt.y, r + 4, 0, Math.PI * 2);
                ctx.fill();
                ctx.beginPath();
                ctx.fillStyle = '#4dff88';
                ctx.arc(pt.x, pt.y, r, 0, Math.PI * 2);
                ctx.fill();
                ctx.strokeStyle = '#ffffff';
                ctx.lineWidth = 2;
                ctx.stroke();
            }

            let gap = 0;
            if (you && botN > 0) {
                gap = Math.hypot(you.x - sx / botN, you.y - sy / botN);
            }

            const el = document.querySelector('.gx-coord-debug');
            if (el) {
                const alive = bots.filter(b => b.isAlive).length;
                const mapStr = c.mapLocked
                    ? `DUAL ${Math.round(c.mapW)}×${Math.round(c.mapH)}`
                    : 'MAP ?';
                let head = 'YOU ?';
                if (you) {
                    const f = this.frac(you.x, you.y, p);
                    head = `WS ${Math.round(you.x)},${Math.round(you.y)} (${Math.round(f.fx * 100)}%,${Math.round(f.fy * 100)}%)`;
                }
                const sight = TargetHub.status();
                const seeN = TargetHub.seeCount();
                el.textContent = `${mapStr} · ${head} · ${sight} see:${seeN} · gap=${Math.round(gap)} · bots ${alive}`;
            }
        }
    };

    function initCoordDebug() {
        setInterval(() => {
            if (!minimap.ready) return;
        }, 200);
    }

    const panelId = "gx_panel_" + Math.floor(100 + Math.random() * 900);

    const loadStylesheet = () => {
        const style = document.createElement("style");
        style.textContent = `
            :root {
                --gx-blue: #1e90ff;
                --gx-green: #22c55e;
                --gx-red: #ef4444;
                --gx-white: #ffffff;
                --gx-black: #0a0a0f;
            }
            .gx-info-panel {
                box-shadow: 0 8px 28px rgba(0,0,0,0.55), 0 0 0 1px rgba(30,144,255,0.35);
                z-index: 99999999;
                background: linear-gradient(160deg, rgba(10,10,15,0.94) 0%, rgba(12,28,55,0.92) 100%);
                position: fixed;
                top: 12px;
                left: 12px;
                display: flex;
                flex-direction: row;
                align-items: center;
                justify-content: flex-start;
                flex-wrap: wrap;
                align-content: flex-start;
                gap: 6px 8px;
                row-gap: 8px;
                font-family: 'Segoe UI', 'Noto Sans Arabic', 'PingFang SC', system-ui, sans-serif;
                border: 1px solid rgba(30,144,255,0.55);
                border-radius: 12px;
                padding: 8px 10px;
                pointer-events: auto;
                backdrop-filter: blur(12px);
                transition: opacity 0.2s ease, box-shadow 0.2s ease, padding 0.15s ease;
                width: max-content;
                max-width: min(560px, calc(100vw - 24px));
                height: auto;
                max-height: calc(100vh - 24px);
                overflow: visible;
                box-sizing: border-box;
                user-select: none;
            }
            .gx-info-panel[dir="rtl"] { direction: rtl; }
            .gx-info-panel.gx-dragging { box-shadow: 0 12px 36px rgba(0,0,0,0.65), 0 0 0 1px rgba(30,144,255,0.7); opacity: 0.95; }

            /* Свёрнутое состояние — маленькая полоска */
            .gx-info-panel.gx-collapsed {
                padding: 6px 10px;
                gap: 4px 6px;
            }
            .gx-info-panel.gx-collapsed .gx-status-wrap,
            .gx-info-panel.gx-collapsed .gx-sep,
            .gx-info-panel.gx-collapsed .gx-stat,
            .gx-info-panel.gx-collapsed .gx-actions,
            .gx-info-panel.gx-collapsed .gx-nick-wrap {
                display: none !important;
            }
            .gx-info-panel.gx-collapsed .gx-brand-mini { display: inline-flex; }
            .gx-brand-mini {
                display: none;
                align-items: center;
                gap: 6px;
                color: var(--gx-white);
                font-size: 11px;
                font-weight: 800;
                cursor: pointer;
                letter-spacing: 0.4px;
            }
            .gx-brand-mini:hover { color: var(--gx-blue); }
            .gx-brand-mini .mini-dot {
                width: 8px; height: 8px; border-radius: 50%;
                background: var(--gx-green);
                box-shadow: 0 0 6px rgba(34,197,94,0.55);
            }
            .gx-brand-mini .mini-dot.status-offline { background: var(--gx-red); box-shadow: 0 0 6px rgba(239,68,68,0.55); }
            .gx-brand-mini .mini-dot.status-stopped { background: #fbbf24; box-shadow: 0 0 6px rgba(251,191,36,0.45); }
            .gx-brand-mini .mini-dot.status-running { background: var(--gx-green); animation: pulse 1.5s infinite; }

            .gx-drag-handle {
                cursor: grab;
                color: var(--gx-blue);
                font-size: 14px;
                font-weight: 800;
                padding: 2px 4px;
                letter-spacing: 1px;
                line-height: 1;
                flex: 0 0 auto;
            }
            .gx-drag-handle:active { cursor: grabbing; }
            .gx-status-wrap {
                display: flex;
                align-items: center;
                flex-wrap: wrap;
                gap: 6px;
                flex: 1 1 auto;
                min-width: 0;
                max-width: 100%;
            }
            .gx-status-row {
                display: flex;
                align-items: center;
                flex-wrap: wrap;
                gap: 6px;
                min-width: 0;
            }
            .gx-brand {
                color: var(--gx-white);
                font-size: 12px;
                font-weight: 800;
                cursor: pointer;
                text-decoration: none;
                letter-spacing: 0.4px;
                transition: color 0.15s ease, transform 0.15s ease;
                line-height: 1.2;
                word-break: break-word;
            }
            .gx-brand:hover { color: var(--gx-blue); transform: scale(1.04); }
            .bot-text {
                color: rgba(255,255,255,0.85);
                font-size: 11px;
                font-weight: 600;
                line-height: 1.2;
                white-space: normal;
                overflow-wrap: anywhere;
                word-break: break-word;
            }
            .status-indicator {
                display: inline-block;
                width: 8px; height: 8px;
                border-radius: 50%;
                flex-shrink: 0;
                vertical-align: middle;
            }
            .status-offline  { background: var(--gx-red); box-shadow: 0 0 6px rgba(239,68,68,0.55); }
            .status-running  { background: var(--gx-green); box-shadow: 0 0 6px rgba(34,197,94,0.55); animation: pulse 1.5s infinite; }
            .status-stopped  { background: #fbbf24; box-shadow: 0 0 6px rgba(251,191,36,0.45); }
            .status-green    { background: var(--gx-green); box-shadow: 0 0 6px rgba(34,197,94,0.55); }
            @keyframes pulse { 0%,100% { opacity: 1; } 50% { opacity: 0.5; } }

            /* Ник игрока */
            .gx-nick-wrap {
                display: inline-flex;
                align-items: center;
                gap: 4px;
                background: rgba(30,144,255,0.12);
                border: 1px solid rgba(30,144,255,0.35);
                border-radius: 8px;
                padding: 3px 8px;
                flex: 0 1 auto;
                min-width: 0;
                max-width: 100%;
            }
            .gx-nick-label {
                color: rgba(255,255,255,0.55);
                font-size: 10px;
                font-weight: 600;
                letter-spacing: 0.3px;
                flex: 0 0 auto;
            }
            .gx-nick-value {
                color: #4dff88;
                font-size: 11px;
                font-weight: 700;
                max-width: 160px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                flex: 0 1 auto;
                min-width: 0;
            }
            .gx-nick-value.gx-nick-empty { color: rgba(255,255,255,0.35); font-style: italic; }
            .gx-nick-see {
                color: #fbbf24;
                font-size: 9px;
                font-weight: 700;
                margin-left: 2px;
                flex: 0 0 auto;
            }
            .gx-nick-see.gx-see-ok { color: #4dff88; }

            .stopwatch {
                color: var(--gx-green);
                font-size: 10px;
                font-weight: 700;
                display: none;
                letter-spacing: 1px;
                line-height: 1;
                flex: 0 0 auto;
            }
            .gx-sep {
                width: 1px; height: 22px;
                background: rgba(30,144,255,0.35);
                margin: 0 2px;
                flex: 0 0 auto;
                align-self: center;
            }
            .gx-actions {
                display: flex;
                flex-wrap: wrap;
                align-items: center;
                gap: 6px;
                flex: 1 1 auto;
                min-width: 0;
            }
            .gx-stat {
                display: flex;
                flex-direction: column;
                align-items: center;
                min-width: 44px;
                flex: 0 0 auto;
            }
            .gx-stat-label {
                color: rgba(255,255,255,0.45);
                font-size: 9px;
                text-transform: uppercase;
                letter-spacing: .5px;
                white-space: normal;
                text-align: center;
                overflow-wrap: anywhere;
            }
            .gx-stat-value {
                color: var(--gx-white);
                font-size: 13px;
                font-weight: 700;
            }
            .bot-button, .small-button {
                color: var(--gx-white);
                border: 1px solid rgba(255,255,255,0.2);
                cursor: pointer;
                border-radius: 8px;
                transition: background 0.15s, transform 0.12s, box-shadow 0.15s;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                font-family: inherit;
                white-space: normal;
                overflow-wrap: anywhere;
                text-align: center;
                flex: 0 1 auto;
                max-width: 100%;
            }
            .bot-button {
                background: rgba(30,144,255,0.18);
                padding: 7px 12px;
                font-size: 11px;
                font-weight: 700;
                gap: 5px;
                border-color: rgba(30,144,255,0.45);
            }
            .small-button {
                background: rgba(255,255,255,0.06);
                padding: 6px 10px;
                font-size: 10px;
                font-weight: 600;
                gap: 3px;
            }
            .bot-button:hover, .small-button:hover {
                background: rgba(30,144,255,0.32);
                transform: scale(1.04);
            }
            .bot-button.start-btn  { background: rgba(34,197,94,0.18); border-color: rgba(34,197,94,0.5); color: var(--gx-green); }
            .bot-button.start-btn:hover { background: rgba(34,197,94,0.3); }
            .bot-button.stop-btn   { background: rgba(239,68,68,0.18); border-color: rgba(239,68,68,0.5); color: #ff6b6b; }
            .bot-button.stop-btn:hover { background: rgba(239,68,68,0.3); }
            .bot-button.hide-btn { padding: 7px 10px; font-size: 12px; color: var(--gx-white); }
            .bot-button.cfg-btn    { padding: 7px 10px; font-size: 14px; border-radius: 8px; }

            #settings-modal {
                position: fixed;
                top: 70px;
                left: 12px;
                background: linear-gradient(160deg, rgba(10,10,15,0.96), rgba(12,28,55,0.94));
                padding: 14px;
                border: 1px solid rgba(30,144,255,0.5);
                border-radius: 12px;
                z-index: 100000000;
                color: var(--gx-white);
                font-family: 'Segoe UI', 'Noto Sans Arabic', 'PingFang SC', system-ui, sans-serif;
                box-shadow: 0 10px 32px rgba(0,0,0,0.5);
                backdrop-filter: blur(12px);
                width: min(320px, calc(100vw - 24px));
                max-width: calc(100vw - 24px);
                box-sizing: border-box;
                overflow-wrap: anywhere;
            }
            #settings-modal[dir="rtl"] { direction: rtl; }
            .settings-title {
                font-size: 13px;
                font-weight: 700;
                color: var(--gx-white);
                margin-bottom: 10px;
                text-align: center;
                letter-spacing: .5px;
                overflow-wrap: anywhere;
            }
            .settings-grid { display: grid; grid-template-columns: 1fr; gap: 10px; }
            @media (max-width: 420px) {
                .settings-grid { grid-template-columns: 1fr; }
                .keybind-grid { grid-template-columns: 1fr !important; }
                .gx-sep { display: none; }
            }
            .settings-label {
                margin: 0 0 4px;
                font-size: 11px;
                font-weight: 600;
                color: rgba(255,255,255,0.7);
                overflow-wrap: anywhere;
            }
            .settings-hint {
                font-size: 10px;
                color: rgba(30,144,255,0.9);
                margin: 0 0 8px;
                line-height: 1.35;
                overflow-wrap: anywhere;
            }
            .settings-input {
                width: 100%;
                padding: 7px 10px;
                background: rgba(0,0,0,0.35);
                border: 1px solid rgba(30,144,255,0.4);
                color: var(--gx-white);
                border-radius: 8px;
                font-size: 11px;
                font-family: inherit;
                box-sizing: border-box;
                transition: border-color 0.15s, box-shadow 0.15s;
                -webkit-appearance: none;
            }
            .settings-input:focus {
                border-color: var(--gx-blue);
                box-shadow: 0 0 8px rgba(30,144,255,0.35);
                outline: none;
            }
            .keybind-section { margin-top: 10px; }
            .keybind-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 8px; margin-top: 6px; }
            .keybind-row  { display: flex; align-items: center; justify-content: space-between; gap: 6px; flex-wrap: wrap; }
            .keybind-label { color: rgba(255,255,255,0.75); font-size: 10px; flex-grow: 1; overflow-wrap: anywhere; }
            .settings-key {
                padding: 4px 8px;
                background: rgba(0,0,0,0.35);
                border: 1px solid rgba(30,144,255,0.4);
                color: var(--gx-white);
                border-radius: 6px;
                font-size: 10px;
                text-align: center;
                width: 32px;
            }
            .settings-save {
                background: linear-gradient(135deg, #1e90ff, #0d6efd);
                color: #fff;
                border: none;
                padding: 10px;
                cursor: pointer;
                border-radius: 8px;
                font-size: 12px;
                font-weight: 700;
                text-align: center;
                width: 100%;
                margin-top: 12px;
                transition: background 0.15s, transform 0.12s;
                display: block;
                box-sizing: border-box;
                white-space: normal;
                overflow-wrap: anywhere;
            }
            .settings-save:hover {
                background: linear-gradient(135deg, #3aa0ff, #1e7eef);
                transform: scale(1.02);
            }

            #gx-minimap {
                position: fixed;
                right: 14px;
                bottom: 14px;
                z-index: 99999999;
                width: 200px;
                background: linear-gradient(160deg, rgba(10,10,15,0.9), rgba(12,28,55,0.88));
                border: 1px solid rgba(30,144,255,0.4);
                border-radius: 12px;
                padding: 8px;
                backdrop-filter: blur(10px);
                box-shadow: 0 6px 24px rgba(0,0,0,0.45);
                pointer-events: none;
                font-family: 'Segoe UI', system-ui, sans-serif;
            }
            #gx-minimap canvas {
                display: block;
                width: 200px;
                height: 200px;
                border-radius: 8px;
            }
            .gx-minimap-head {
                display: flex;
                justify-content: space-between;
                font-size: 9px;
                font-weight: 700;
                letter-spacing: 0.6px;
                margin-bottom: 5px;
            }
            .gx-mm-you { color: #22c55e; }
            .gx-mm-sight { color: #60a5fa; }
            .gx-mm-bots { color: #93c5fd; }
            .gx-minimap-foot {
                margin-top: 5px;
                font-size: 9px;
                color: rgba(255,255,255,0.7);
                white-space: normal;
                word-break: break-all;
                line-height: 1.25;
            }
        `;
        (document.head || document.documentElement).appendChild(style);
    };

    function enablePanelDrag(panel) {
        const handle = panel.querySelector('.gx-drag-handle') || panel;
        let ox = 0, oy = 0, dragging = false;
        const onDown = (e) => {
            if (e.target.closest('button, a, input')) return;
            dragging = true;
            panel.classList.add('gx-dragging');
            const r = panel.getBoundingClientRect();
            ox = e.clientX - r.left;
            oy = e.clientY - r.top;
            e.preventDefault();
        };
        const onMove = (e) => {
            if (!dragging) return;
            const r = panel.getBoundingClientRect();
            const w = r.width || 200;
            const h = r.height || 60;
            const x = Math.max(0, Math.min(window.innerWidth - Math.min(w, 40), e.clientX - ox));
            const y = Math.max(0, Math.min(window.innerHeight - Math.min(h, 40), e.clientY - oy));
            panel.style.left = x + 'px';
            panel.style.top = y + 'px';
            panel.style.right = 'auto';
            try { localStorage.setItem('gx-panel-pos', JSON.stringify({ x, y })); } catch (err) {}
        };
        const onUp = () => {
            if (!dragging) return;
            dragging = false;
            panel.classList.remove('gx-dragging');
        };
        handle.addEventListener('mousedown', onDown);
        document.addEventListener('mousemove', onMove);
        document.addEventListener('mouseup', onUp);
        try {
            const saved = JSON.parse(localStorage.getItem('gx-panel-pos') || 'null');
            if (saved && typeof saved.x === 'number' && typeof saved.y === 'number') {
                panel.style.left = saved.x + 'px';
                panel.style.top = saved.y + 'px';
            }
        } catch (e) {}
    }

    // Свернуть/развернуть панель + скрыть/показать minimap
    window._gxTogglePanel = () => {
        const panel = document.querySelector('.gx-info-panel');
        if (!panel) return;
        panel.classList.toggle('gx-collapsed');
        try {
            localStorage.setItem('gx-panel-collapsed', panel.classList.contains('gx-collapsed') ? '1' : '0');
        } catch (e) {}
    };

    // Только minimap
    window._gxToggleMinimap = () => {
        minimap.toggle();
        try {
            localStorage.setItem('gx-minimap-hidden', minimap.visible ? '0' : '1');
        } catch (e) {}
    };

    const initUI = () => {
        const panel = document.createElement('div');
        panel.className = 'gx-info-panel';
        if (UI_RTL) panel.setAttribute('dir', 'rtl');
        panel.lang = UI_LANG;
        panel.innerHTML = `
            <span class="gx-drag-handle" title="${t('drag')}">⋮⋮</span>
            <span class="gx-brand-mini" onclick="window._gxTogglePanel()" title="${t('settings')}">
                <span class="mini-dot" id="mini-dot"></span>𝗯𝗼𝘁𝘇.𝗽𝗿𝗼
            </span>
            <div class="gx-status-wrap">
                <div class="gx-status-row">
                    <a class="gx-brand" href="https://botz.pro" target="_blank" rel="noopener">𝗯𝗼𝘁𝘇.𝗽𝗿𝗼</a>
                    <span class="status-indicator status-green" id="status-light"></span>
                    <span class="bot-text" id="status">${t('online')}</span>
                </div>
                <span id="stopwatch" class="stopwatch">00:00</span>
            </div>
            <div class="gx-nick-wrap" title="${t('followHint')}">
                <span class="gx-nick-label">${t('playerNick')}:</span>
                <span class="gx-nick-value gx-nick-empty" id="gx-nick-value">—</span>
                <span class="gx-nick-see" id="gx-nick-see">see:0</span>
            </div>
            <div class="gx-sep"></div>
            <div class="gx-stat">
                <span class="gx-stat-label">${t('bots')}</span>
                <span class="gx-stat-value gx-botCount">${botConfig.botCount}</span>
            </div>
            <div class="gx-sep"></div>
            <div class="gx-actions">
                <button class="bot-button start-btn gx-stfinish" onclick="window._gxStart('stfinish')">▶ ${t('start')}</button>
                <button class="bot-button stop-btn gx-stop" onclick="window._gxStart('stop')" style="display:none">■ ${t('stop')}</button>
                <button class="bot-button hide-btn" onclick="window._gxTogglePanel()" title="${t('hide')} (H)">✕</button>
                <button class="bot-button cfg-btn" onclick="window._gxCfg()" title="${t('settings')}">⚙</button>
                <button class="bot-button cfg-btn" onclick="window._gxToggleMinimap()" title="minimap">🗺</button>
            </div>
        `;
        const container = document.getElementById(panelId);
        if (container) container.appendChild(panel);
        enablePanelDrag(panel);

        // восстановить свёрнутость
        try {
            if (localStorage.getItem('gx-panel-collapsed') === '1') {
                panel.classList.add('gx-collapsed');
            }
        } catch (e) {}

        // восстановить скрытие миникарты
        try {
            if (localStorage.getItem('gx-minimap-hidden') === '1') {
                minimap.visible = false;
                const wrap = document.getElementById('gx-minimap');
                if (wrap) wrap.style.display = 'none';
            }
        } catch (e) {}

        minimap.init();
        updateNickDisplay();
        setInterval(updateNickDisplay, 250);
    };

    // Обновляет надпись ника в панели + сколько ботов его видят
    function updateNickDisplay() {
        const nickEl = document.getElementById('gx-nick-value');
        const seeEl  = document.getElementById('gx-nick-see');
        const dotEl  = document.getElementById('mini-dot');
        if (!nickEl) return;

        const nick = botConfig.followNick || '';
        if (nick) {
            nickEl.textContent = nick;
            nickEl.classList.remove('gx-nick-empty');
        } else {
            nickEl.textContent = '—';
            nickEl.classList.add('gx-nick-empty');
        }

        const seeN = TargetHub.seeCount();
        if (seeEl) {
            seeEl.textContent = 'see:' + seeN;
            if (seeN > 0) seeEl.classList.add('gx-see-ok');
            else seeEl.classList.remove('gx-see-ok');
        }

        // мини-точка отражает состояние кнопки старт/стоп
        if (dotEl) {
            const light = document.getElementById('status-light');
            dotEl.className = 'mini-dot';
            if (light) {
                if (light.classList.contains('status-running')) dotEl.classList.add('status-running');
                else if (light.classList.contains('status-offline')) dotEl.classList.add('status-offline');
                else if (light.classList.contains('status-stopped')) dotEl.classList.add('status-stopped');
            }
        }
    }

    const initEventListeners = () => {
        document.addEventListener("keydown", event => {
            const tag = (event.target && event.target.tagName) || '';
            if (tag === 'INPUT' || tag === 'TEXTAREA') return;
            const key = event.key.toUpperCase();
            if (key === botConfig.keybinds.feedKey) {
                event.preventDefault();
                if (bots.length > 0) bots.forEach(b => { try { b.eject(); } catch(e) {} });
            } else if (key === botConfig.keybinds.splitKey) {
                event.preventDefault();
                if (bots.length > 0) bots.forEach(b => { try { b.split(); } catch(e) {} });
            } else if (key === botConfig.keybinds.hideKey) {
                event.preventDefault();
                window._gxTogglePanel();
            }
        });
        const nickWatch = () => {
            const el = document.getElementById('nick');
            if (!el || el.__gxNickBound) return;
            el.__gxNickBound = true;
            const sync = () => syncFollowNickFromOfficial();
            el.addEventListener('input', sync);
            el.addEventListener('change', sync);
            sync();
        };
        nickWatch();
        setInterval(nickWatch, 1000);
    };

    window._gxCfg = () => {
        const modal = document.getElementById('settings-modal');
        if (modal) { saveSettings(); modal.remove(); }
        else createSettingsModal();
    };

    function createSettingsModal() {
        const modal = document.createElement('div');
        modal.id = 'settings-modal';
        if (UI_RTL) modal.setAttribute('dir', 'rtl');
        modal.lang = UI_LANG;
        modal.innerHTML = `
            <div class="settings-title">${t('settingsTitle')}</div>
            <div class="settings-hint">${t('followHint')}</div>
            <div class="settings-grid">
                <div>
                    <div class="settings-label">${t('botAmount')}</div>
                    <input type="number" id="gx-bot-qty" class="settings-input" min="1" max="200"
                           value="${localStorage.getItem('gx-bot-qty') || '150'}">
                </div>
            </div>
            <div class="keybind-section">
                <div class="settings-label">${t('keybinds')}</div>
                <div class="keybind-grid">
                    <div class="keybind-row"><span class="keybind-label">${t('split')}</span>
                        <input type="text" class="settings-key" id="key-split" value="${botConfig.keybinds.splitKey}" maxlength="1"></div>
                    <div class="keybind-row"><span class="keybind-label">${t('feed')}</span>
                        <input type="text" class="settings-key" id="key-feed" value="${botConfig.keybinds.feedKey}" maxlength="1"></div>
                    <div class="keybind-row"><span class="keybind-label">${t('hideKey')}</span>
                        <input type="text" class="settings-key" id="key-hide" value="${botConfig.keybinds.hideKey}" maxlength="1"></div>
                </div>
            </div>
            <button class="settings-save" onclick="window._gxCfg()">${t('save')}</button>
        `;
        document.body.appendChild(modal);
    }

    function saveSettings() {
        const amountEl = document.getElementById('gx-bot-qty');
        const splitKeyEl = document.getElementById('key-split');
        const feedKeyEl = document.getElementById('key-feed');
        const hideKeyEl = document.getElementById('key-hide');

        if (amountEl) {
            let botAmount = parseInt(amountEl.value);
            if (isNaN(botAmount) || botAmount < 1) botAmount = 150;
            if (botAmount > 200) botAmount = 200;
            localStorage.setItem('gx-bot-qty', botAmount);
            botConfig.botCount = botAmount;
        }

        bots.forEach(b => { b.name = LOCKED_BOT_NAME; b._nameLocked = false; });

        if (splitKeyEl) botConfig.keybinds.splitKey = splitKeyEl.value.toUpperCase() || 'X';
        if (feedKeyEl) botConfig.keybinds.feedKey = feedKeyEl.value.toUpperCase() || 'C';
        if (hideKeyEl) botConfig.keybinds.hideKey = hideKeyEl.value.toUpperCase() || 'H';
        localStorage.setItem('gx-keybinds', JSON.stringify(botConfig.keybinds));

        if (!botConfig.startedBots) {
            const bc = document.querySelector(".gx-botCount");
            if (bc) bc.textContent = `${botConfig.botCount}`;
        }
        updateBotCount();
    }

    const loadKeybinds = () => {
        const saved = localStorage.getItem('gx-keybinds');
        if (saved) {
            try {
                const parsed = JSON.parse(saved);
                botConfig.keybinds.feedKey = parsed.feedKey || 'C';
                botConfig.keybinds.splitKey = parsed.splitKey || 'X';
                botConfig.keybinds.hideKey = parsed.hideKey || 'H';
            } catch(e) {}
        }
    };

    const initWebSocket = () => {
        try { mainTracker.flushPending(); } catch (e) {}
    };

    const initInterval = () => {
        setInterval(() => { syncPlayerCords(); }, 50);
        initCoordDebug();
    };

    window._gxStart = startBots;

    if (/agar\.io/.test(location.hostname)) {
        let injected = false;
        const doInject = () => {
            if (injected) return;
            injected = true;
            loadKeybinds();
            initWebSocket();
            initInterval();
            const mount = () => {
                if (document.getElementById(panelId)) return;
                const container = document.createElement("div");
                container.id = panelId;
                (document.body || document.documentElement).appendChild(container);
                loadStylesheet();
                initUI();
                initEventListeners();
            };
            if (document.body || document.documentElement) mount();
            else {
                const waitForGame = setInterval(() => {
                    if (document.body || document.documentElement) {
                        clearInterval(waitForGame);
                        mount();
                    }
                }, 20);
            }
        };
        const tryInject = () => {
            if (injected) return;
            const target = document.body || document.documentElement;
            if (!target) { setTimeout(tryInject, 10); return; }
            doInject();
        };
        tryInject();
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', tryInject, { once: true });
        }
        const observer = new MutationObserver(() => {
            if (document.body) { observer.disconnect(); tryInject(); }
        });
        observer.observe(document.documentElement || document, { childList: true, subtree: true });
    }
})();
