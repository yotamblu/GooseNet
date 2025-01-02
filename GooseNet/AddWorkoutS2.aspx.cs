using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class AddWorkoutS2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        protected string GenerateIntervalHTML()
        {
            int amountOfIntervals = int.Parse(Request.QueryString["intervals"]);
            string HTMLString = "";
            for (int i = 1; i <= amountOfIntervals; i++)
            {
                HTMLString += $" <div class=\"interval\">\r\n" +
                    $"            <h3>Interval {i}</h3>\r\n" +
                    $"            Duration Value Type:<br /><br />\r\n\r\n" +
                    $"            <select name=\"intervalDurationType{i}\">\r\n\r\n" +
                    $"                <option value=\"minutes\">Minutes</option>\r\n" +
                    $"                <option value=\"seconds\">Seconds</option>\r\n" +
                    $"                <option value=\"meters\">Meters</option>\r\n" +
                    $"                <option value=\"kilometers\">kilometers</option>\r\n\r\n" +
                    $"            </select><br /><br />\r\n" +
                    $"            Interval Duration Value:\r\n" +
                    $"            <input name=\"intervalDurationValue{i}\" /> <br /><br />\r\n" +
                    $"            Interval Pace:<br />\r\n" +
                    $"            <input class=\"paceInput\" name=\"intervalPaceMinutes{i}\" type=\"number\"  placeholder=\"Minutes\"/>:<input class=\"paceInput\"   type=\"number\" name=\"intervalPaceSeconds{i}\" placeholder=\"Seconds\"/>\r\n" +
                    $"        </div>";
            }
            
            return HTMLString;
        }

    }
}