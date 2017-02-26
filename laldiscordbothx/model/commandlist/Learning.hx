package laldiscordbothx.model.commandlist;

import discordhx.guild.GuildMember;
import discordbothx.log.Logger;
import discordbothx.core.CommunicationContext;
import discordhx.channel.TextChannel;
import discordhx.role.Role;

class Learning extends LALBaseCommand {
    public function new(context: CommunicationContext) {
        super(context);

        nbRequiredParams = 1;
        paramsUsage = '(the role you want)';
    }

    override public function process(args: Array<String>): Void {
        var author = context.message.author;

        if (args.length > 0) {
            if (context.message.guild != null) {
                var wantedRole = 'learning ' + args.join(' ').toLowerCase();

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
                            context.sendToChannel(l('success_remove', cast [author]));
                        }).catchError(function (error: Dynamic) {
                            Logger.exception(error);
                            context.sendToChannel(l('fail_remove', cast [author]));
                        });
                    } else {
                        member.addRole(targetRole).then(function (member: GuildMember): Void {
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
                context.sendToChannel(l('wrong_channel', cast [author]));
            }
        } else {
            context.sendToChannel(l('parse_error', cast [author]));
        }
    }
}
