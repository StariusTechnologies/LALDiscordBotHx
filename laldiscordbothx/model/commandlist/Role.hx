package laldiscordbothx.model.commandlist;

import laldiscordbothx.config.Config;
import laldiscordbothx.config.Config;
import haxe.Timer;
import discordhx.guild.GuildMember;
import discordbothx.log.Logger;
import discordbothx.core.CommunicationContext;
import discordhx.channel.TextChannel;
import discordhx.role.Role as DiscordRole;

class Role extends LALBaseCommand {
    public function new(context: CommunicationContext) {
        super(context);

        nbRequiredParams = 1;
        paramsUsage = '(the role you want)';
    }

    override public function process(args: Array<String>): Void {
        var author = context.message.author;

        if (args.length > 0) {
            if (context.message.guild != null) {
                var wantedRole = args.join(' ').toLowerCase();
                var specialSnowflake: Bool = Config.NO_TAGS_GO_WITH_NATIVE_SERVERS.indexOf(context.message.guild.id) > -1;

                var roleIsRelay = wantedRole == 'relay';
                var roleIsNative = wantedRole.indexOf('native') == 0;
                var roleIsFluent = wantedRole.indexOf('fluent') == 0;
                var roleIsLearning = wantedRole.indexOf('learning') == 0;
                var roleIsStudying = wantedRole.indexOf('studying') == 0;
    
                if (roleIsRelay || roleIsNative || roleIsFluent || roleIsLearning || roleIsStudying) {
                    var channel:TextChannel = cast context.message.channel;
                    var roles: Array<DiscordRole> = channel.guild.roles.array();
                    var roleExists = false;
                    var targetRole: DiscordRole = null;
                    var member: GuildMember = context.message.guild.member(author);

                    for (role in roles) {
                        if (role.name.toLowerCase() == wantedRole) {
                            roleExists = true;
                            targetRole = role;
                        }
                    }

                    if (roleExists && targetRole != null) {
                        if (member.roles.has(targetRole.id)) {
                            member.removeRole(targetRole).then(function (member: GuildMember): Void {
                                if (Config.NO_TAGS_GO_WITH_NATIVE_SERVERS.indexOf(context.message.guild.id) < 0 || roleIsNative) {
                                    Timer.delay(function () {
                                        var channel:TextChannel = cast context.message.channel;
                                        var roles: Array<DiscordRole> = channel.guild.roles.array();
                                        var memberRoles: Array<DiscordRole> = member.roles.array();
                                        var hasNative = false;

                                        for (role in memberRoles) {
                                            if (role.name.toLowerCase().indexOf('native') == 0 && role.name.toLowerCase() != wantedRole) {
                                                hasNative = true;
                                            }
                                        }

                                        if (!specialSnowflake && memberRoles.length < 1 || specialSnowflake && !hasNative) {
                                            for (role in roles) {
                                                if (role.name.toLowerCase().indexOf(Config.NO_TAGS_ROLE.toLowerCase()) > -1) {
                                                    member.addRole(role);
                                                }
                                            }
                                        }
                                    }, 100);
                                }

                                context.sendToChannel(l('success_remove', cast [author]));
                            }).catchError(function (error: Dynamic) {
                                Logger.exception(error);
                                context.sendToChannel(l('fail_remove', cast [author]));
                            });
                        } else {
                            member.addRole(targetRole).then(function (member: GuildMember): Void {
                                if (Config.NO_TAGS_GO_WITH_NATIVE_SERVERS.indexOf(context.message.guild.id) < 0 || roleIsNative) {
                                    Timer.delay(function () {
                                        for (role in roles) {
                                            if (role.name.toLowerCase().indexOf(Config.NO_TAGS_ROLE.toLowerCase()) > -1) {
                                                member.removeRole(role);
                                            }
                                        }
                                    }, 100);
                                }

                                context.sendToChannel(l('success_give', cast [author]));
                            }).catchError(function (error: Dynamic) {
                                Logger.exception(error);
                                context.sendToChannel(l('fail_give', cast [author]));
                            });
                        }
                    } else {
                        context.sendToChannel(l('not_found', cast [author]));
                    }
                } else {
                    context.sendToChannel(l('forbidden', cast [author]));
                }
            } else {
                context.sendToChannel(l('wrong_channel', cast [author]));
            }
        } else {
            context.sendToChannel(l('parse_error', cast [author]));
        }
    }
}
