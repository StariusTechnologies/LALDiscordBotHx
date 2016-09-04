package model.commandlist;

import utils.Logger;
import discordhx.channel.TextChannel;
import discordhx.channel.ServerChannel;
import utils.DiscordUtils;
import translations.LangCenter;

class Role implements ICommandDefinition {
    public var paramsUsage = '(the role you want)';
    public var description: String;
    public var hidden = false;

    private var _context: CommunicationContext;

    public function new(context: CommunicationContext) {
        var serverId = DiscordUtils.getServerIdFromMessage(context.getMessage());

        _context = context;
        description = LangCenter.instance.translate(serverId, 'model.commandlist.role.description');
    }

    public function process(args: Array<String>): Void {
        var author = _context.getMessage().author;

        if (args.length > 0) {
            if (!_context.getMessage().channel.isPrivate) {
                var wantedRole = args.join(' ').toLowerCase();
                var roleIsRelay = wantedRole == 'relay';
                var roleIsNative = wantedRole.indexOf('native') == 0;
                var roleIsFluent = wantedRole.indexOf('fluent') == 0;
                var roleIsLearning = wantedRole.indexOf('learning') == 0;
                var roleIsStudying = wantedRole.indexOf('studying') == 0;
    
                if (roleIsRelay || roleIsNative || roleIsFluent || roleIsLearning || roleIsStudying) {
                    var channel:TextChannel = cast _context.getMessage().channel;
                    var roles = channel.server.roles;
                    var roleExists = false;
                    var targetRole = null;

                    for (role in roles) {
                        if (role.name.toLowerCase() == wantedRole) {
                            roleExists = true;
                            targetRole = role;
                        }
                    }

                    if (roleExists && targetRole != null) {
                        if (Core.instance.memberHasRole(author, targetRole)) {
                            Core.instance.removeMemberFromRole(author, targetRole, function (err: Dynamic): Void {
                                if (err == null) {
                                    _context.sendToChannel('model.commandlist.role.process.success_remove', cast [author]);
                                } else {
                                    Logger.exception(err);
                                    _context.sendToChannel('model.commandlist.role.process.fail_remove', cast [author]);
                                }
                            });
                        } else {
                            Core.instance.addMemberToRole(author, targetRole, function (err: Dynamic): Void {
                                if (err == null) {
                                    _context.sendToChannel('model.commandlist.role.process.success_give', cast [author]);
                                } else {
                                    Logger.exception(err);
                                    _context.sendToChannel('model.commandlist.role.process.fail_give', cast [author]);
                                }
                            });
                        }
                    } else {
                        _context.sendToChannel('model.commandlist.role.process.not_found', cast [author]);
                    }
                } else {
                    _context.sendToChannel('model.commandlist.role.process.forbidden', cast [author]);
                }
            } else {
                _context.sendToChannel('model.commandlist.role.process.wrong_channel', cast [author]);
            }
        } else {
            _context.sendToChannel('model.commandlist.role.process.parse_error', cast [author]);
        }
    }
}
