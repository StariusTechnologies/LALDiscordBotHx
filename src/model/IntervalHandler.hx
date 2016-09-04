package model;

import utils.Logger;
import haxe.Timer;
import model.entity.Subreddit;

class IntervalHandler {
    public static var instance(get, null): IntervalHandler;
    private static var _instance: IntervalHandler;

    private var _intervalList: Map<String, Timer>;

    public static function get_instance(): IntervalHandler {
        if (_instance == null) {
            _instance = new IntervalHandler();
        }

        return _instance;
    }

    public static function initialize(): Void {
        _instance = new IntervalHandler();
    }

    public function refreshIntervalList() {
        Logger.info('Refreshing interval list...');
        Entity.getAll(Subreddit, handleSubreddits);
    }

    private function new() {
        _intervalList = new Map<String, Timer>();
        refreshIntervalList();
    }

    private function handleSubreddits(subreddits: Array<Subreddit>): Void {
        Logger.info('Found ' + subreddits.length + ' subreddit(s) to check!');
        for (subreddit in subreddits) {
            if (_intervalList.exists(subreddit.name)) {
                _intervalList.get(subreddit.name).stop();
            }

            var timer = new Timer(subreddit.refreshInterval * 60 * 1000);

            timer.run = subreddit.checkForNewPosts;

            subreddit.checkForNewPosts();
            _intervalList.set(subreddit.name, timer);
        }
    }
}
