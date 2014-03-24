/**
 * Created by PMAN on 16.03.14.
 */
package klock.liveobject.utils {

	import flash.display.MovieClip;
	import flash.display.Stage;
	public class GlobalStage extends MovieClip
	{
		public static var STAGE	:Stage;
		public static var ROOT	:MovieClip;

		public function GlobalStage( _stage:Stage, _root:MovieClip )
		{
			STAGE = _stage;
			ROOT = _root;
		}
	}
}
