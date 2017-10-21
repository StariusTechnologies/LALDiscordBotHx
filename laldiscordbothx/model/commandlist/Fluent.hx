package laldiscordbothx.model.commandlist;

import haxe.Timer;
import laldiscordbothx.config.Config;
import discordhx.guild.GuildMember;
import discordbothx.log.Logger;
import discordbothx.core.CommunicationContext;
import discordhx.channel.TextChannel;
import discordhx.role.Role;

class Fluent extends LALBaseCommand {
    public function new(context: CommunicationContext) {
        super(context);

        nbRequiredParams = 1;
        paramsUsage = '(the role you want)';
    }

    override public function process(args: Array<String>): Void {
        var author = context.message.author;

        if (args.length > 0) {
            if (context.message.guild != null) {
                var wantedRole = 'fluent ' + args.join(' ').toLowerCase();
                var specialSnowflake: Bool = Config.NO_TAGS_GO_WITH_NATIVE_SERVERS.indexOf(context.message.guild.id) > -1;

                var channel: TextChannel = cast context.message.channel;
                var roles: Array<Role> = channel.guild.roles.array();
                var roleExists = false;
                var targetRole: Role = null;
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
                            if (!specialSnowflake) {
                                Timer.delay(function () {
                                    var channel:TextChannel = cast context.message.channel;
                                    var roles: Array<Role> = channel.guild.roles.array();
                                    var memberRoles: Array<Role> = member.roles.array();

                                    if (memberRoles.length < 1) {
                                        for (role in roles) {
                                            if (role.name.toLowerCase().indexOf(Config.NO_TAGS_ROLE.toLowerCase()) > -1) {
                                                member.addRole(role);
                                            }
                                        }
                                    }
                                }, 100);
                            }

                            context.sendToChannel(l('success_remove', cast [author]));

                            if (needNativeReminder(specialSnowflake, member, wantedRole)) {
                                context.sendToChannel(l('native_reminder', cast [author]));
                            }
                        }).catchError(function (error: Dynamic) {
                            Logger.exception(error);
                            context.sendToChannel(l('fail_remove', cast [author]));
                        });
                    } else {
                        member.addRole(targetRole).then(function (member: GuildMember): Void {
                            if (!specialSnowflake) {
                                Timer.delay(function () {
                                    for (role in roles) {
                                        if (role.name.toLowerCase().indexOf(Config.NO_TAGS_ROLE.toLowerCase()) > -1) {
                                            member.removeRole(role);
                                        }
                                    }
                                }, 100);
                            }

                            context.sendToChannel(l('success_give', cast [author]));

                            if (needNativeReminder(specialSnowflake, member, wantedRole)) {
                                context.sendToChannel(l('native_reminder', cast [author]));
                            }
                        }).catchError(function (error: Dynamic) {
                            Logger.exception(error);
                            context.sendToChannel(l('fail_give', cast [author]));
                        });
                    }
                } else {
                    context.sendToChannel(l('not_found', cast [author]));
                }
            } else {
                context.sendToChannel(l('wrong_channel', cast [author]));
            }
        } else {
            context.sendToChannel(l('parse_error', cast [author]));
        }
    }

    private function needNativeReminder(specialSnowflake: Bool, member: GuildMember, wantedRole: String): Bool {
        var reminderNeeded = false;

        if (specialSnowflake) {
            var memberRoles: Array<Role> = member.roles.array();
            var hasNative = false;

            for (role in memberRoles) {
                if (role.name.toLowerCase().indexOf('native') == 0 && role.name.toLowerCase() != wantedRole) {
                    hasNative = true;
                }
            }

            reminderNeeded = !hasNative;
        }

        return reminderNeeded;
    }
}
