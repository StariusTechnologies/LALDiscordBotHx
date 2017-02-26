package laldiscordbothx.event;

import laldiscordbothx.config.Config;
import discordhx.guild.Guild;
import discordhx.guild.GuildMember;
import laldiscordbothx.model.Db;
import discordbothx.core.DiscordBot;
import laldiscordbothx.model.entity.Staff;
import laldiscordbothx.translations.LangCenter;
import laldiscordbothx.model.entity.WelcomeMessage;
import discordbothx.core.CommunicationContext;
import discordhx.user.User;
import laldiscordbothx.model.entity.User as UserEntity;
import laldiscordbothx.model.entity.Channel;
import laldiscordbothx.model.entity.Server;
import discordbothx.log.Logger;
import discordhx.client.Client;

class ClientEventHandler extends EventHandler<Client> {
    private override function process(): Void {
        eventEmitter.on(cast ClientEvent.READY, readyHandler);
        eventEmitter.on(cast ClientEvent.GUILD_CREATE, registerEntities);
        eventEmitter.on(cast ClientEvent.CHANNEL_CREATE, registerEntities);
        eventEmitter.on(cast ClientEvent.GUILD_MEMBER_ADD, serverNewMemberHandler);
        eventEmitter.on(cast ClientEvent.GUILD_MEMBER_REMOVE, serverMemberRemovedHandler);
    }

    private function readyHandler(): Void {
        Db.instance;
        LangCenter.instance;

        registerEntities();
    }

    private function registerEntities(): Void {
        Server.registerServers();
        Channel.registerChannels();
        UserEntity.registerUsers();
    }

    private function serverNewMemberHandler(member: GuildMember): Void {
        Logger.info('New member joined!');
        registerEntities();

        var context: CommunicationContext = new CommunicationContext();
        var guild: Guild = member.guild;
        var user: User = member.user;

        for (role in guild.roles.array()) {
            if (role.name.toLowerCase().indexOf(Config.NO_TAGS_ROLE.toLowerCase()) > -1) {
                member.addRole(role);
            }
        }

        WelcomeMessage.getForServer(guild.id, function(err: Dynamic, message: String) {
            if (err != null) {
                Logger.exception(err);
                context.sendToOwner(LangCenter.instance.translate(guild.id, 'fail', cast [user.username, guild.name]));
            } else {
                if (message != null) {
                    context.sendTo(user, message);
                }
            }
        });

        Staff.getStaffToNotifyAboutNewMember(guild.id, function (staffToNotify: Array<Staff>): Void {
            if (staffToNotify != null && staffToNotify.length > 0) {
                for (staff in staffToNotify) {
                    context.sendTo(
                        DiscordBot.instance.client.users.get(staff.idUser),
                        LangCenter.instance.translate(guild.id, 'notification_to_staff', cast [user.username, guild.name])
                    );
                }
            }
        });
    }

    private function serverMemberRemovedHandler(member: GuildMember): Void {
        Logger.info('Member removed!');

        var context: CommunicationContext = new CommunicationContext();
        var guild: Guild = member.guild;
        var user: User = member.user;

        Staff.getStaffToNotifyAboutNewMember(guild.id, function (staffToNotify: Array<Staff>): Void {
            if (staffToNotify != null && staffToNotify.length > 0) {
                for (staff in staffToNotify) {
                    context.sendTo(
                        DiscordBot.instance.client.users.get(staff.idUser),
                        LangCenter.instance.translate(guild.id, 'notification_to_staff', cast [user.username, guild.name])
                    );
                }
            }
        });
    }
}
