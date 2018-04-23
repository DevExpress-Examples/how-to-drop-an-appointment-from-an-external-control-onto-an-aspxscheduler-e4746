using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;
using DevExpress.Web.ASPxScheduler;
using DevExpress.Web.ASPxScheduler.Internal;
using DevExpress.XtraScheduler;

namespace WebApplication1 {
    public partial class Default : System.Web.UI.Page {
        protected void Page_Load(object sender, EventArgs e) {
        }

        protected void ObjectDataSourceResources_ObjectCreated(object sender, ObjectDataSourceEventArgs e) {
            if(Session["CustomResourceDataSource"] == null) {
                Session["CustomResourceDataSource"] = new CustomResourceDataSource(GetCustomResources());
            }
            e.ObjectInstance = Session["CustomResourceDataSource"];
        }

        BindingList<CustomResource> GetCustomResources() {
            BindingList<CustomResource> resources = new BindingList<CustomResource>();
            resources.Add(CreateCustomResource(1, "Max Fowler"));
            resources.Add(CreateCustomResource(2, "Nancy Drewmore"));
            resources.Add(CreateCustomResource(3, "Pak Jang"));
            return resources;
        }

        private CustomResource CreateCustomResource(int res_id, string caption) {
            CustomResource cr = new CustomResource();
            cr.ResID = res_id;
            cr.Name = caption;
            return cr;
        }

        public Random RandomInstance = new Random();
        private CustomAppointment CreateCustomAppointment(string subject, object resourceId, int status, int label) {
            CustomAppointment apt = new CustomAppointment();
            apt.Subject = subject;
            apt.OwnerId = resourceId;
            Random rnd = RandomInstance;
            int rangeInMinutes = 60 * 24;
            apt.StartTime = DateTime.Today + TimeSpan.FromMinutes(rnd.Next(0, rangeInMinutes));
            apt.EndTime = apt.StartTime + TimeSpan.FromMinutes(rnd.Next(0, rangeInMinutes / 4));
            apt.Status = status;
            apt.Label = label;
            return apt;
        }

        protected void ObjectDataSourceAppointment_ObjectCreated(object sender, ObjectDataSourceEventArgs e) {
            if(Session["CustomAppointmentDataSource"] == null) {
                Session["CustomAppointmentDataSource"] = new CustomAppointmentDataSource(GetCustomAppointments());
            }
            e.ObjectInstance = Session["CustomAppointmentDataSource"];
        }

        BindingList<CustomAppointment> GetCustomAppointments() {
            BindingList<CustomAppointment> appointments = new BindingList<CustomAppointment>();;
            CustomResourceDataSource resources = Session["CustomResourceDataSource"] as CustomResourceDataSource;
            if(resources != null) {
                foreach(CustomResource item in resources.Resources) {
                    string subjPrefix = item.Name + "'s ";
                    appointments.Add(CreateCustomAppointment(subjPrefix + "meeting", item.ResID, 2, 5));
                    appointments.Add(CreateCustomAppointment(subjPrefix + "travel", item.ResID, 3, 6));
                    appointments.Add(CreateCustomAppointment(subjPrefix + "phone call", item.ResID, 0, 10));                       
                }                    
            }
            return appointments;
        }

        protected void ASPxScheduler1_BeforeExecuteCallbackCommand(object sender, DevExpress.Web.ASPxScheduler.SchedulerCallbackCommandEventArgs e) {
            if(e.CommandId == "CRTAPT")
                e.Command = new CreateAppointmentCallbackCommand((ASPxScheduler)sender);
        }
    }

    public class CreateAppointmentCallbackCommand : SchedulerCallbackCommand {
        public override string Id { get { return "CRTAPT"; } }

        private DateTime start;
        protected DateTime Start { get { return start; } set { start = value; } }

        public CreateAppointmentCallbackCommand(ASPxScheduler control)
            : base(control) {

        }

        protected override void ParseParameters(string parameters) {
            //base.ParseParameters(parameters);

            Start = DateTime.Parse(parameters);
        }

        protected override void ExecuteCore() {
            //base.ExecuteCore();

            CreateAppointment();
        }

        protected void CreateAppointment() {
            ASPxGridView grid = (ASPxGridView)this.Control.Page.FindControl("ASPxGridView1");
            ASPxHiddenField hf = (ASPxHiddenField)this.Control.Page.FindControl("hf");
            object[] rowValues = (object[])grid.GetRowValues(Convert.ToInt32(hf["row"]), new string[] { "Name", "TypeName" });

            Appointment apt = this.Control.Storage.CreateAppointment(AppointmentType.Normal);

            apt.Subject = String.Format("{1} - {0}", rowValues[0], rowValues[1]);
            apt.Start = Start;
            apt.End = Start.AddHours(0.5);
            apt.ResourceId = Convert.ToInt32(hf["res"]);

            this.Control.Storage.Appointments.Add(apt);
            this.Control.ActiveView.SelectAppointment(apt);
        }
    }
}