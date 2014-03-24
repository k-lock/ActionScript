package {

import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;

import klock.liveobject.KLiveObject;
import klock.liveobject.component.TabObject;
import klock.liveobject.component.VTab;
import klock.liveobject.component.VTab_A;
import klock.liveobject.component.VTab_B;
import klock.liveobject.utils.GlobalStage;
import klock.simpleComponents.components.Label;
import klock.simpleComponents.components.Panel;
import klock.simpleComponents.components.base.BaseLayout;
import klock.simpleComponents.fonts.FontManager;

[SWF(frameRate="60", width="700", height="700", backgroundColor="0x0")]
public class KLiveObjectStarter extends Sprite {

    [Embed(source = "/../embed/shop.swf")]
    public static var SHOP:Class;


    public function KLiveObjectStarter() {

        new FontManager()
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);

		initGlobalStage()
		init()

    }

	private function initGlobalStage():void {
		new GlobalStage( this.stage, this.root as MovieClip)
	}

    private function init():void {

		var m:assetClip;
		addChild( m=new assetClip())

		var tabNames:Vector.<String> = new Vector.<String>();
		tabNames.push("Properties","Library")

		var tabContainer:TabObject = new TabObject({x:100,y:100},tabNames,this);




		tabContainer.tabs[0].tabContainer.addChild(new VTab_A(tabContainer, m ))
		tabContainer.tabs[1].tabContainer.addChild(new VTab_B(tabContainer, m ))






     // KLiveObject.startSession( m, stage )

      /*  for each( var d:Object in kTools.objectz )
        {
            trace( "obj ", d.obj, d.obj.name,"| par ", d.par, d.par.name, DisplayObjectContainer(d.par).getChildIndex(d.obj ) )
        }*/


    }

  /*  private function addPreloader():Preloader {
        return addChild( new Preloader() ) as Preloader
    }*/

    private function addDisplayObject():void {
		/* 	var shape:Shape = new Shape();
		shape.name = "MainClipSource"
		shape.x = 50
		shape.y = 50
		addChild(shape);//addChild(new Shape());addChild(new Shape());addChild(new Shape());addChild(new Shape());addChild(new Shape());addChild(new Shape());

		var g:Graphics = shape.graphics;
		g.beginFill(0x0033ff)
		g.drawRoundRect(0,0, 25, 25, 10,10)
		g.endFill();

		var s4:Sprite = new Sprite()
		addChild(s4)


		var g:Graphics = s4.graphics;
		g.beginFill(0x0033ff)
		g.drawRoundRect(300,10, 25, 25, 10,10)
		g.endFill();

		//    addPreloader()

		   var shape:Sprite = new Sprite();
		 shape.name = "MainClipSource"
		 shape.x = 50
		 shape.y = 50
		 addChild(shape);

		 var g:Graphics = shape.graphics;
		 g.beginFill(0x0033ff)
		 g.drawRoundRect(0,0, 25, 25, 10,10)
		 g.endFill();

		 var s:Sprite = new Sprite()
		 s.name="spriteII"

		 shape.addChild(s)
		 var s2:Sprite = new Sprite()
		 s2.name="spriteIII"
		 shape.addChild(s2)

		 var s3:Sprite = new Sprite()
		 s2.addChild(s3)

		 var s4:Sprite = new Sprite()
		 s3.addChild(s4)


		 var g:Graphics = s.graphics;
		 g.beginFill(0x0033ff)
		 g.drawRoundRect(300,10, 25, 25, 10,10)
		 g.endFill();

		 var g:Graphics = s2.graphics;
		 g.beginFill(0x0033ff)
		 g.drawRoundRect(10,300, 205, 25, 10,10)
		 g.endFill();

		 var shop:MovieClip = new SHOP()
		 shop.name = "shop"


		 */

		/*		var s4:Sprite = new Sprite()
		 s4.name = "s14"
		 addChild(s4)


		 for( var o:uint=0;o<18;o++){
		 var s:Sprite = new Sprite();
		 var g:Graphics = s.graphics
		 g.beginFill( 0xffffff*Math.random())
		 g.drawRect( -25,-25,50,50)
		 g.endFill()

		 s.name = "sprit_"+o
		 s.x = 250+ Math.random()*250
		 s.y = Math.random()*500

		 s4.addChild(s);

		 }




		 var s5:Sprite = new Sprite()
		 s5.name = "s15"
		 DisplayObjectContainer(s4.getChildAt(3)).addChild(s5)

		 var s6:Sprite = new Sprite()
		 s6.name = "s16"
		 s5.addChild(s6)


		 var s5a:Sprite = new Sprite()
		 s5.name = "s15"
		 DisplayObjectContainer(s5.getChildAt(0)).addChild(s5a)

		 var s6a:Sprite = new Sprite()
		 s6a.name = "s16extraLongNameIdenditier"
		 s5a.addChild(s6a)

		 var s7a:Sprite = new Sprite()
		 s7a.name = "s7aextraLongNameIdenditier"
		 s6a.addChild(s7a)

		 var s8a:Sprite = new Sprite()
		 s8a.name = "s8aextraLongNavcvcv"
		 s7a.addChild(s8a)*/

		// var loader:Loader = shop.getChildAt(0) as Loader;
		//  var c1:DisplayObjectContainer = loader.getChildAt(0) as DisplayObjectContainer
//addChild(loader)


		//trace( " || ", this.name, this, this.numChildren )
		//kTools.listChildren(this)

		//  kTools.objectz = []
		//   kTools.tracerDisplayList(stage,"==>");
        var shape:Sprite = new Sprite();
        shape.name = "MainClipSource"
        shape.x = 0
        shape.y = 0
        addChild(shape);


        var ch2:Shape = new Shape()
        ch2.name = "ch2"
        ch2.x = 200
        ch2.y = 400
        var ch1:MovieClip = new MovieClip()
        var ch3:MovieClip = new MovieClip()
        ch1.x = 400
        ch1.y = 200
        ch1.name = "NAME_OF_LONG_AND"

        var g:Graphics = ch2.graphics;
        g.beginFill(0xccff33)
        g.drawRoundRect(-125,-75, 250, 150, 10,10)
        g.endFill();

        g = shape.graphics;
        g.beginFill(0x0033ff)
        g.drawRoundRect(0,0, 25, 25, 10,10)
        g.endFill();

        ch1.addChild( ch2 )
        shape.addChild(ch1)
        ch1.addChild(ch3)

       // ch1.addChild( new Preloader() )
    }
/*
    public static function getBoundsAfterTransformation(bounds:Rectangle, m:Matrix):Rectangle {

        if (m == null) return bounds;

        var topLeft:Point = m.transformPoint(bounds.topLeft);
        var topRight:Point = m.transformPoint(new Point(bounds.right, bounds.top));
        var bottomRight:Point = m.transformPoint(bounds.bottomRight);
        var bottomLeft:Point = m.transformPoint(new Point(bounds.left, bounds.bottom));

        var left:Number = Math.min(topLeft.x, topRight.x, bottomRight.x, bottomLeft.x);
        var top:Number = Math.min(topLeft.y, topRight.y, bottomRight.y, bottomLeft.y);
        var right:Number = Math.max(topLeft.x, topRight.x, bottomRight.x, bottomLeft.x);
        var bottom:Number = Math.max(topLeft.y, topRight.y, bottomRight.y, bottomLeft.y);
        return new Rectangle(left, top, right - left, bottom - top);
    }

    public static function getAnchorPoint(o:DisplayObject):Point {
        var onStage:Boolean;
        var p:DisplayObjectContainer = o.parent;
        onStage=(o.stage!=null);
        if (!onStage) KLiveObjectStarter.Instance.stage.addChild(o);
        var res:Point=new Point();
        var rect:Rectangle=o.getRect(o);
        res.x=-1*rect.x;
        res.y=-1*rect.y;
        if (!onStage) {
            KLiveObjectStarter.Instance.stage.removeChild(o);
            if (p) {
                p.addChild(o);
            }
        }
        return res;
    }*/
}

}
