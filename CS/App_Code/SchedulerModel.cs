using DevExpress.Web.ASPxScheduler;
using DevExpress.XtraScheduler;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for SchedulerModel
/// </summary>

public class MySimpleAppointment
{
    public int ID { get; set; }
    public int ResourceID { get; set; }
    public string Title { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public string Label { get; set; }
    public string Status { get; set; }
    public string MyRecurrenceInfo { get; set; }
    public int Type { get; set; }
    public string Description { get; set; }
}
public class MySimpleAppointmentAdapter
{
    public BindingList<MySimpleAppointment> Read()
    {
        return AppointmentsData;
    }
    public int Create(MySimpleAppointment postedItem)
    {
        int newID = 0;
        foreach (MySimpleAppointment item in AppointmentsData)
            if (newID < item.ID)
                newID = item.ID;
        newID = newID + 1;
        AppointmentsData[AppointmentsData.Count - 1].ID = newID;
        return newID;
    }
    public void Update(MySimpleAppointment postedItem)
    {
        var editedItem = AppointmentsData.First(i => i.ID == postedItem.ID);
        LoadNewValues(editedItem, postedItem);
    }
    public void Delete(MySimpleAppointment deletedItem)
    {
        var item = AppointmentsData.First(i => i.ID == deletedItem.ID);
        AppointmentsData.Remove(item);
    }
    protected void LoadNewValues(MySimpleAppointment newItem, MySimpleAppointment postedItem)
    {
        newItem.Label = postedItem.Label;
        newItem.EndDate = postedItem.EndDate;
        newItem.MyRecurrenceInfo = postedItem.MyRecurrenceInfo;
        newItem.ResourceID = postedItem.ResourceID;
        newItem.StartDate = postedItem.StartDate;
        newItem.Status = postedItem.Status;
        newItem.Title = postedItem.Title;
        newItem.Type = postedItem.Type;
        newItem.Description = postedItem.Description;
    }
    private BindingList<MySimpleAppointment> AppointmentsData
    {
        get
        {
            var key = "34FAA431-CF79-4869-9488-93F6AAE81263";
            var Session = HttpContext.Current.Session;
            if (Session[key] == null)
                Session[key] = GenerateDS();
            return (BindingList<MySimpleAppointment>)Session[key];
        }
    }
    public BindingList<MySimpleAppointment> GenerateDS()
    {
        BindingList<MySimpleAppointment> model = new BindingList<MySimpleAppointment>();
        return model;
    }
}
public class MySimpleResource
{
    public int ResourceID { get; set; }
    public string ResourceName { get; set; }
}
public class MySimpleResourceAdapter
{
    public BindingList<MySimpleResource> GetDS()
    {
        BindingList<MySimpleResource> model = new BindingList<MySimpleResource>();
        model.Add(new MySimpleResource() { ResourceID = 1, ResourceName = "Resource1" });
        model.Add(new MySimpleResource() { ResourceID = 2, ResourceName = "Resource2" });
        return model;
    }
}

public class MySimpleStandardAppointment
{
    public string Title { get; set; }
    public int DurationInHours { get; set; }
    public string Label { get; set; }
    public string Status { get; set; }
    public static BindingList<MySimpleStandardAppointment> GenerateDS()
    {
        BindingList<MySimpleStandardAppointment> model = new BindingList<MySimpleStandardAppointment>();
        model.Add(new MySimpleStandardAppointment() { Label = "Red", Status = "Delayed", Title = "App1", DurationInHours = 1 });
        model.Add(new MySimpleStandardAppointment() { Label = "Green", Status = "Answered", Title = "App2", DurationInHours = 2 });
        model.Add(new MySimpleStandardAppointment() { Label = "Red", Status = "Delayed", Title = "App3", DurationInHours = 1 });
        model.Add(new MySimpleStandardAppointment() { Label = "Green", Status = "Answered", Title = "App4", DurationInHours = 7 });
        model.Add(new MySimpleStandardAppointment() { Label = "Green", Status = "Delayed", Title = "App5", DurationInHours = 1 });
        return model;
    }
}