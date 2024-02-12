package states.stages.objects;

typedef AnimationData =
{
    var name:String;
    var prefix:String;
    var frame:Int;
}

class TV extends FlxSprite
{
    public static var animationData:Array<AnimationData>;

    public var glitch:FlxSprite;
    public var peppino:FlxSprite;

    public function new(?image:String = 'lung/monitor', ?x:Float = 850, ?y:Float = -80)
    {
        super(x, y);
        frames = Paths.getSparrowAtlas(image);

        setGraphicSize(Std.int(width * 0.85));
        updateHitbox();
        antialiasing = false;

        animationData = [
            {name : 'random1', prefix : 'Random', frame : 0},
            {name : 'random2', prefix : 'Random', frame : 1},
            {name : 'random3', prefix : 'Random', frame : 2},
            {name : 'random4', prefix : 'Random', frame : 3},
            {name : 'randomamongus', prefix : 'Random', frame : 4},
            {name : 'randommonsta', prefix : 'Random', frame : 5},
            {name : 'important1', prefix : 'Important', frame : 0},
            {name : 'important2', prefix : 'Important', frame : 1},
            {name : 'important3', prefix : 'Important', frame : 2},
            {name : 'important4', prefix : 'Important', frame : 3},
            {name : 'important5', prefix : 'Important', frame : 4},
            {name : 'important2nofish', prefix : 'Important', frame : 5},
            {name : 'blackscreen', prefix : 'Blackscreen', frame : 0}
        ];

        for (stuff in 0...animationData.length)
            animation.addByIndices(animationData[stuff].name, animationData[stuff].prefix, [animationData[stuff].frame], '', 1);

        animation.play('blackscreen', false);

        glitch = new FlxSprite(x, y);
        glitch.frames = Paths.getSparrowAtlas('lung/static');
        glitch.animation.addByPrefix('idle', 'vhs', 24, true);
        glitch.animation.play('idle', false);
        glitch.scale.x = 0.845;
        glitch.scale.y = 0.85;
        glitch.updateHitbox();
        glitch.alpha = 0.5;
        glitch.visible = false;
        glitch.antialiasing = false;

        peppino = new FlxSprite(x, y);
        peppino.frames = Paths.getSparrowAtlas('funni/peppino_tv');
        peppino.animation.addByPrefix('idle', 'Idle', 24, true);
        peppino.animation.play('idle', false);
        peppino.setGraphicSize(Std.int(peppino.width * 1.6));
        peppino.updateHitbox();
        peppino.alpha = 0;
        peppino.visible = false;
        peppino.antialiasing = false;
    }
}