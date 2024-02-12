package states.stages.objects;

class Bubbles extends BGSprite
{
    var timer:FlxTimer;

    public function new(x:Float, y:Float, image:String = 'lung/BubbleTexture', mult:Float, lifeTime:Float)
    {
        super(image, x, y);

        antialiasing = false;
        alpha = 0.7;
        active = true;

        setGraphicSize(Std.int(width * FlxG.random.float(0.1, 0.8)));
        velocity.x = FlxG.random.float(-100, 100);
        velocity.y = FlxG.random.float(-350, -250);
        acceleration.x = FlxG.random.float((-150 * mult), (150 * mult));
        acceleration.y = FlxG.random.float(-180 * mult);

        timer = new FlxTimer();
        Lung.timersMap.set(Std.string(this), timer);
        timer.start(lifeTime / 1000, function(tmr:FlxTimer) {
            Lung.timersMap.remove(Std.string(this));
            destroy();
        });
    }

    public static function createBubble(x:Float, y:Float, mult:Float, lifeTime:Float)
    {
        var bubble = new Bubbles(x, y, mult, lifeTime);
        return bubble;
    }
}
