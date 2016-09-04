package model.commandlist;

import utils.DiscordUtils;
import discordhx.channel.TextChannel;
import discordhx.channel.PMChannel;
import discordhx.user.User;
import translations.LangCenter;
import discordhx.message.Message;

class Avatar implements ICommandDefinition {
    public var paramsUsage = '';
    public var description: String;
    public var hidden = false;

    private var _context: CommunicationContext;

    public function new(context: CommunicationContext) {
        var serverId = DiscordUtils.getServerIdFromMessage(context.getMessage());

        _context = context;
        description = LangCenter.instance.translate(serverId, 'model.commandlist.avatar.description');
    }

    public function process(args: Array<String>): Void {
        var author = _context.getMessage().author;
        var userlist: Array<User> = null;

        if (_context.getMessage().channel.isPrivate) {
            var channel: PMChannel = cast _context.getMessage().channel;
            userlist = [Core.userInstance, channel.recipient];
        } else {
            var channel: TextChannel = cast _context.getMessage().channel;
            userlist = channel.server.members;
        }

        var user: User = DiscordUtils.getUserFromSearch(userlist, args.join(' '));

        if (user != null) {
            _context.rawSendToChannel(author + ' => ' + user.avatarURL);
        } else {
            _context.sendToChannel('model.commandlist.avatar.process.not_found', cast [author]);
        }
    }
}
