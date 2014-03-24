/**
 * Created by PMAN on 21.02.14.
 */
package klock.liveobject.event {
import flash.events.Event;

public class KObjectTabEvent extends Event {

    public static const TAB_CHANGE_EVENT:String = "tabChangeEvent"
    public var tabID:int = -1;

    public function KObjectTabEvent(type:String, tabIndex:int, bubbles:Boolean = false, cancelable:Boolean = false) {

        super(type, bubbles, cancelable);
        tabID = tabIndex;
    }


}
}
