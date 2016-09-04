package model.commandlist;

import discordhx.message.Message;
import discordhx.channel.TextChannel;
import discordhx.permission.Role;
import utils.DiscordUtils;
import translations.LangCenter;

class Rolelist implements ICommandDefinition {
    public var paramsUsage = '';
    public var description: String;
    public var hidden = false;

    private var _context: CommunicationContext;

    public function new(context: CommunicationContext) {
        var serverId = DiscordUtils.getServerIdFromMessage(context.getMessage());

        _context = context;
        description = LangCenter.instance.translate(serverId, 'model.commandlist.rolelist.description');
    }

    public function process(args: Array<String>): Void {
        var author = _context.getMessage().author;

        if (!_context.getMessage().channel.isPrivate) {
            var channel:TextChannel = cast _context.getMessage().channel;
            var roles = channel.server.roles;
            var message = LangCenter.instance.translate(channel.server.id, 'model.commandlist.rolelist.process.answer') + '\n\n';
            var roleNames: Array<String> = roles.map(function (role: Role): String {
                return role.name;
            });

            roleNames.sort(function (a:String, b:String): Int {
                var ret = 0;

                if (a < b) {
                    ret = -1;
                } else if (a > b) {
                    ret = 1;
                }

                return ret;
            });

            for (role in roleNames) {
                var currentRole:String = role.toLowerCase();
                var roleIsRelay = currentRole == 'relay';
                var roleIsNative = currentRole.indexOf('native') == 0;
                var roleIsFluent = currentRole.indexOf('fluent') == 0;
                var roleIsLearning = currentRole.indexOf('learning') == 0;
                var roleIsStudying = currentRole.indexOf('studying') == 0;

                if (roleIsRelay || roleIsNative || roleIsFluent || roleIsLearning || roleIsStudying) {
                    message += role + '\n';
                }
            }

            sendMessage(DiscordUtils.splitLongMessage(message), 0, function () {
                _context.sendToChannel('model.commandlist.rolelist.process.witness', cast [author]);
            });
        } else {
            _context.sendToChannel('model.commandlist.rolelist.process.wrong_channel', cast [author]);
        }
    }

    private function sendMessage(content: Array<String>, index: Int, callback: Void->Void): Void {
        var messageSentCallback: Dynamic->Message->Void = null;

        if (index >= content.length - 1) {
            messageSentCallback = function(err: Dynamic, msg: Message) {
                callback();
            };
        } else {
            messageSentCallback = function(err: Dynamic, msg: Message) {
                sendMessage(content, index + 1, callback);
            };
        }

        _context.rawSendToAuthor(content[index], messageSentCallback);
    }
}
