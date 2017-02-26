package laldiscordbothx.model;

import haxe.PosInfos;
import laldiscordbothx.translations.LangCenter;
import laldiscordbothx.utils.DiscordUtils;
import discordbothx.core.CommunicationContext;
import discordbothx.service.BaseCommand;

class LALBaseCommand extends BaseCommand {
    public function new(context: CommunicationContext, ?pos: PosInfos) {
        super(context);
        
        var serverId = DiscordUtils.getServerIdFromMessage(context.message);
        var commandName = pos.className.substr(pos.className.lastIndexOf('.') + 1).toLowerCase();

        description = LangCenter.instance.translate(serverId, Bot.PROJECT_NAME + '.model.commandlist.' + commandName + '.description');
    }

    private function l(str: String, ?vars: Array<String>, variant: Int = 0, ?pos: PosInfos) {
        var commandName = pos.className.substr(pos.className.lastIndexOf('.') + 1).toLowerCase();

        return LangCenter.instance.translate(
            DiscordUtils.getServerIdFromMessage(context.message),
            Bot.PROJECT_NAME + '.model.commandlist.' + commandName + '.' + str,
            vars,
            variant
        );
    }
}
