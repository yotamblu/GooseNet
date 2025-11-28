using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
namespace GooseNet
{
    public partial class HandleStrengthWorkout : System.Web.UI.Page
    {

        FirebaseService firebaseService;
        public StrengthWorkout GenerateStrengthWorkout()
        {
           string json =  Decode(Request.QueryString["json"]);
            StrengthWorkout strengthWorkout = JsonConvert.DeserializeObject<StrengthWorkout>(json);
            strengthWorkout.WorkoutDate = ConvertToMMDDYYYY(strengthWorkout.WorkoutDate);
            // add athlete names to list
            strengthWorkout.AthleteNames = new List<string>();

            if (Request.QueryString["athleteName"] != null)
            {
                strengthWorkout.AthleteNames.Add(Request.QueryString["athleteName"]);
            }
            else
            {
                strengthWorkout.AthleteNames = firebaseService.GetData<Flock>($"Flocks/{Session["userName"].ToString()}/{Request.QueryString["flockName"].ToString()}").athletesUserNames;
            }

            strengthWorkout.CoachName = Session["userName"].ToString();

            return strengthWorkout;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
           
            firebaseService = new FirebaseService();
            StrengthWorkout strengthWorkout = GenerateStrengthWorkout();

            Guid guid = Guid.NewGuid();

            string guidString = guid.ToString("N").Substring(0, 12);

             firebaseService.InsertData($"PlannedStrengthWorkouts/{guidString}", strengthWorkout);

            Response.Redirect("MyAthletes.aspx");
            
            
        }

        public static string ConvertToMMDDYYYY(string input)
        {
            if (string.IsNullOrWhiteSpace(input))
                return string.Empty;

            DateTime dt = DateTime.ParseExact(input, "yyyy-MM-dd", CultureInfo.InvariantCulture);
            return dt.ToString("MM/dd/yyyy");
        }

        public static string Decode(string input)
        {
            if (string.IsNullOrEmpty(input))
                return string.Empty;

            // First decode + into space
            string normalized = input.Replace("+", " ");

            // Then decode %XX sequences safely
            return Uri.UnescapeDataString(normalized);
        }
    }
}