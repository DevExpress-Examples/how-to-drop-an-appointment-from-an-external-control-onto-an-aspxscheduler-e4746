# How to drop an appointment from an external control onto an ASPxScheduler


<p>This example illustrates how to drag and drop an item from an external control (<a href="http://documentation.devexpress.com/#AspNet/clsDevExpressWebASPxGridViewASPxGridViewtopic">ASPxGridView</a> in this example) to the ASPxScheduler area in order to create an appointment. Note that this example is an extended version of the <a href="https://www.devexpress.com/Support/Center/p/E4292">ASPxScheduler - How to drag a row from ASPxGridView and create an appointment based on its values</a> code example. The advantage of this project is that an appointment is created in a time cell to which a corresponding grid item is dropped, whereas in the previous example, the appointment time is taken from a grid row. <br><br>Here is a screenshot that illustrates a sample application in action during the custom drag-and-drop operation:<br><img src="https://raw.githubusercontent.com/DevExpress-Examples/how-to-drop-an-appointment-from-an-external-control-onto-an-aspxscheduler-e4746/17.1.3+/media/885f5764-10c4-46ab-be38-7a821ec026c1.png"></p>
<p><br><strong>See Also:</strong></p>
<p><a href="https://www.devexpress.com/Support/Center/p/E4708">How to drop an appointment from ASPxScheduler to an external control</a></p>


<h3>Description</h3>

<em>To obtain the current/active time cell, we use non-documented&nbsp;<strong>CalcHitTest</strong>&nbsp;and&nbsp;<strong>initializeCell</strong>&nbsp;client-side methods.</em>&nbsp;<em>Please note that&nbsp;these&nbsp;method implementations can be changed in future versions of the control. Contact us if you&nbsp;use these methods in your project and face any issues while upgrading your project to a newer version. We will&nbsp;provide you with instructions on how to replace or customize&nbsp;these methods.</em>

<br/>


