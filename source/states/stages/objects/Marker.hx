package states.stages.objects;

class Marker extends FlxSprite
{
    public var num:Int = 0;
    public var checked:Bool = false;
    public var fakeLocationX:Float = 0;
    public var fakeLocationY:Float = 0;

    public function new(num:Int)
    {
        super(0, 0);
        loadGraphic(Paths.image('lung/crosshairunselect'));
        setGraphicSize(Std.int(width * 0.6));
        updateHitbox();

        this.num = num;
    }

    public function setSettings(markerX:Float, markerY:Float, fakeLocX:Float, fakeLocY:Float)
    {
        setPosition(markerX, markerY);
        this.fakeLocationX = fakeLocX;
        this.fakeLocationY = fakeLocY;
        //trace(this.num + ' fakeLocationX : ' + this.fakeLocationX + ' fakeLocationY : ' + this.fakeLocationY);
    }
}