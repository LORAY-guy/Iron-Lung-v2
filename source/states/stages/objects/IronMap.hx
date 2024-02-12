package states.stages.objects;

class IronMap extends BGSprite
{
    public var markers:Array<Marker> = [];
    public var ship:BGSprite;
    public var mouseText:FlxText;

    public function new(?image:String = 'lung/MapTex', ?x:Float = 0, ?y:Float = 395) 
    {
        super(image, x, y);
        setGraphicSize(Std.int(width * 0.325));
        updateHitbox();

        ship = new BGSprite('lung/shiplocation', 52, 675);
        ship.setGraphicSize(Std.int(ship.width * 0.5));
        ship.updateHitbox();
        ship.antialiasing = false;
        ship.angle = -90;

        for (i in 0...5)
        {
            var marker:Marker = new Marker(i);
            markers.push(marker);
        }

        mouseText = new FlxText(0, 0, 150, 'X_?\nY_?', 18);
        mouseText.setFormat(Paths.font('vcr.ttf'), 18, FlxColor.WHITE, CENTER, 0);
        mouseText.visible = false;
    }

    public function startShipPart1(totalMvt1)
    {
        FlxTween.tween(ship, {y: 656}, totalMvt1, {ease:FlxEase.sineInOut,  onComplete: function(twn:FlxTween)
        {
            FlxTween.tween(ship, {angle: -45}, totalMvt1 / 2, {ease:FlxEase.sineInOut,  onComplete: function(twn:FlxTween)
            {
                FlxTween.tween(ship, {x: 63}, totalMvt1 / 2, {ease:FlxEase.sineInOut});
                FlxTween.tween(ship, {y: 647.5}, totalMvt1 / 2, {ease:FlxEase.sineInOut,  onComplete: function(twn:FlxTween)
                {
                    FlxTween.tween(ship, {angle: 25}, totalMvt1 / 2, {ease:FlxEase.sineInOut,  onComplete: function(twn:FlxTween)
                    {
                        FlxTween.tween(ship, {x: 100}, totalMvt1, {ease:FlxEase.sineInOut});
                        FlxTween.tween(ship, {y: 653}, totalMvt1, {ease:FlxEase.sineInOut,  onComplete: function(twn:FlxTween)
                        {
                            FlxTween.tween(ship, {angle: -79}, totalMvt1 / 2, {ease:FlxEase.sineInOut,  onComplete: function(twn:FlxTween)
                            {
                                FlxTween.tween(ship, {x: 118}, totalMvt1 * 1.5, {ease:FlxEase.sineInOut});
                                FlxTween.tween(ship, {y: 609}, totalMvt1 * 1.5, {ease:FlxEase.sineInOut,  onComplete: function(twn:FlxTween)
                                {
                                    FlxTween.tween(ship, {angle: 13}, totalMvt1 / 2, {ease:FlxEase.sineInOut,  onComplete: function(twn:FlxTween)
                                    {
                                        FlxTween.tween(ship, {x: 150}, totalMvt1, {ease:FlxEase.sineInOut});
                                        FlxTween.tween(ship, {y: 610}, totalMvt1, {ease:FlxEase.sineInOut,  onComplete: function(twn:FlxTween)
                                        {
                                            FlxTween.tween(ship, {angle: 45}, totalMvt1 / 2, {ease:FlxEase.sineInOut,  onComplete: function(twn:FlxTween)
                                            {
                                                FlxTween.tween(ship, {x: 177}, totalMvt1, {ease:FlxEase.sineInOut});
                                                FlxTween.tween(ship, {y: 626}, totalMvt1, {ease:FlxEase.sineInOut,  onComplete: function(twn:FlxTween)
                                                {
                                                    FlxTween.tween(ship, {angle: -86}, totalMvt1 / 2, {ease:FlxEase.sineInOut,  onComplete: function(twn:FlxTween)
                                                    {
                                                        FlxTween.tween(ship, {x: 183}, totalMvt1 * 2.5, {ease:FlxEase.sineInOut});
                                                        FlxTween.tween(ship, {y: 555}, totalMvt1 * 2.5, {ease:FlxEase.sineInOut,  onComplete: function(twn:FlxTween)
                                                        {
                                                            FlxTween.tween(ship, {angle: -35}, totalMvt1 / 2, {ease:FlxEase.sineInOut,  onComplete: function(twn:FlxTween)
                                                            {
                                                                FlxTween.tween(ship, {x: 201}, totalMvt1, {ease:FlxEase.sineInOut});
                                                                FlxTween.tween(ship, {y: 545}, totalMvt1, {ease:FlxEase.sineInOut,  onComplete: function(twn:FlxTween)
                                                                {
                                                                    FlxTween.tween(ship, {angle: -193}, totalMvt1 / 2, {ease:FlxEase.sineInOut,  onComplete: function(twn:FlxTween)
                                                                    {
                                                                        Lung.tweensMap.set('finalPart1x', FlxTween.tween(ship, {x: 167}, totalMvt1, {ease:FlxEase.sineInOut}));
                                                                        Lung.tweensMap.set('finalPart1y', FlxTween.tween(ship, {y: 553}, totalMvt1, {ease:FlxEase.sineInOut}));
                                                                    }});
                                                                }});
                                                            }});
                                                        }});
                                                    }});
                                                }});
                                            }});
                                        }});
                                    }});
                                }});
                            }});
                        }});
                    }});
                }});
            }});
        }});
    }

    public function startShipPart2(totalMvt2)
    {
        FlxTween.tween(ship, {angle: 0}, totalMvt2, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween)
        {
            FlxTween.tween(ship, {x: 100}, totalMvt2, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween)
            {
                FlxTween.tween(ship, {angle: -90}, totalMvt2 / 1.5, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween)
                {
                    FlxTween.tween(ship, {y: 477}, totalMvt2, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween)
                    {
                        FlxTween.tween(ship, {angle: 0}, totalMvt2, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween)
                        {
                            FlxTween.tween(ship, {x: 137}, totalMvt2, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween)
                            {
                                FlxTween.tween(ship, {angle: 45}, totalMvt2 / 2, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween)
                                {
                                    FlxTween.tween(ship, {x: 150}, totalMvt2, {ease:FlxEase.sineInOut});
                                    FlxTween.tween(ship, {y: 490}, totalMvt2, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween)
                                    {
                                        FlxTween.tween(ship, {angle: 0}, totalMvt2 / 2, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween)
                                        {
                                            FlxTween.tween(ship, {x: 179}, totalMvt2, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween)
                                            {
                                                FlxTween.tween(ship, {angle: -65}, totalMvt2, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween)
                                                {
                                                    FlxTween.tween(ship, {x: 194}, totalMvt2, {ease:FlxEase.sineInOut});
                                                    FlxTween.tween(ship, {y: 467}, totalMvt2, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween)
                                                    {
                                                        FlxTween.tween(ship, {angle: -10}, totalMvt2, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween)
                                                        {
                                                            FlxTween.tween(ship, {x: 215}, totalMvt2, {ease:FlxEase.sineInOut});
                                                            FlxTween.tween(ship, {y: 462}, totalMvt2, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween)
                                                            {
                                                                if (Lung.isGoodEnding) 
                                                                {
                                                                    FlxTween.tween(ship, {angle: -35}, totalMvt2 / 2, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween) 
                                                                    {
                                                                        FlxTween.tween(ship, {x: 221}, totalMvt2, {ease:FlxEase.sineInOut});
                                                                        FlxTween.tween(ship, {y: 456}, totalMvt2, {ease:FlxEase.sineInOut});
                                                                    }});
                                                                } else {
                                                                    FlxTween.tween(ship, {angle: -90}, totalMvt2, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween) 
                                                                    {
                                                                        FlxTween.tween(ship, {y: 446}, totalMvt2 * 6, {ease:FlxEase.sineInOut});
                                                                    }});
                                                                }
                                                            }});
                                                        }});
                                                    }});
                                                }});
                                            }});
                                        }});
                                    }});
                                }});
                            }});
                        }});
                    }});
                }});
            }});
        }});
    }

    public function setUpMarkers()
    {
        var markersLocations:Array<Array<Float>> = [[100, 653], [177, 626], [201, 545], [100, 477], [216, 446]];
        var fakeLocations:Array<Array<Float>> = [[322, 186], [560, 277], [623, 520], [325, 741], [675, 828]];
        for (i in 0...markers.length)
        {
            markers[i].setSettings(markersLocations[i][0], markersLocations[i][1], fakeLocations[i][0], fakeLocations[i][1]);
        }
    }
}