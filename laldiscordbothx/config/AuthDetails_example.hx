package laldiscordbothx.config;

import discordbothx.core.IAuthDetailsProvider;

// Rename this file to AuthDetails before compiling
class AuthDetails_example implements IAuthDetailsProvider {
    // Discord
    public var DISCORD_TOKEN = '';
    public var DISCORD_PASSWORD = '';
    public var BOT_OWNER_ID = '';

    // Cleverbot.io
    public var CLEVERBOTIO_USER = '';
    public var CLEVERBOTIO_KEY = '';

    // Database
    public var DB_HOST = '';
    public var DB_USER = '';
    public var DB_PASSWORD = '';
    public var DB_NAME = '';

    // Oxford English Dictionnary
    public var OED_APP_ID = '';
    public var OED_APP_KEY = '';

    // Getty API
    public var GETTY_KEY = '';
    public var GETTY_SECRET = '';

    public function new() {}
}
