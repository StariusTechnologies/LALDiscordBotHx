package model.entity;

import discordhx.message.Message;
import utils.DiscordUtils;
import utils.Logger;
import haxe.Json;
import nodejs.http.HTTP.HTTPMethod;
import utils.HttpUtils;
import model.Entity.EntityProperties;

class Subreddit extends Entity {
    private static inline var CHANNEL_ID = '210420281401933824';

    public static var properties: EntityProperties = {
        tableName: 'subreddit',
        tableColumns: [
            {
                name: 'id',
                mappedBy: 'id',
                primary: true
            },
            {
                name: 'name',
                mappedBy: 'name',
                primary: false
            },
            {
                name: 'refresh_interval',
                mappedBy: 'refreshInterval',
                primary: false
            },
            {
                name: 'last_id_fetched',
                mappedBy: 'lastIdFetched',
                primary: false
            }
        ]
    };

    public var id: Int;
    public var name: String;
    public var refreshInterval: Int;
    public var lastIdFetched: String;

    public function checkForNewPosts(): Void {
        Logger.info('Checking for new posts on ' + name + '...');

        var path = '/r/' + name + '/new.json?sort=new';

        if (lastIdFetched != null) {
            path += '&before=' + lastIdFetched;
        }

        HttpUtils.query(true, 'www.reddit.com', path, cast HTTPMethod.Get, function (data: String) {
            var response: Dynamic = null;

            try {
                response = Json.parse(data);
            } catch (err: Dynamic) {
                Logger.exception(err);
            }

            if (response != null && Reflect.hasField(response, 'data') && Reflect.hasField(Reflect.field(response, 'data'), 'children')) {
                var children: Array<Dynamic> = response.data.children;

                if (children.length > 0) {
                    Logger.info(children.length + ' new post(s) found on ' + name + '!');

                    var context = Core.instance.createCommunicationContext();
                    var message: String = '';

                    lastIdFetched = children[0].data.name;
                    save();

                    children = children.filter(function (child: Dynamic): Bool {
                        return !child.data.stickied;
                    });

                    for (child in children) {
                        if (message.length > 0) {
                            message += '\n\n';
                        }

                        message += '__' + name + '__: ' + child.data.title + ' | **' + child.data.author + '** | *' + child.data.num_comments + '* :speech_balloon: | <https://www.reddit.com' + child.data.permalink + '>';
                    }

                    sendMessage(context, DiscordUtils.splitLongMessage(message), 0);
                } else {
                    Logger.info('No new post found on ' + name + '.');
                }
            } else {
                Logger.error('Failed to load subreddit updates');
            }
        });
    }

    private function sendMessage(context: CommunicationContext, content: Array<String>, index: Int): Void {
        var messageSentCallback: Dynamic->Message->Void = null;

        if (index < content.length - 1) {
            messageSentCallback = function(err: Dynamic, msg: Message) {
                sendMessage(context, content, index + 1);
            };
        }

        context.rawSendTo(CHANNEL_ID, content[index], messageSentCallback);
    }
}
