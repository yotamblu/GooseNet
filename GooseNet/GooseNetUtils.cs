using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace GooseNet
{

    
    public class GooseNetUtils
    {
        




        public static Dictionary<string,string> GetGarminAPICredentials()
        {
            
            FirebaseService firebaseService = new FirebaseService();
            Dictionary<string, string> creds = firebaseService.GetData<Dictionary<string, string>>("GarminAPICredentials");

            return creds;
        }

        public static bool IsConnectedToUser(HttpSessionState Session,string userName)
        {

            if (Session["requestedAthlete"] != null && Session["requestedAthlete"].ToString() == Session["userName"].ToString())
            {
                string check = Session["requestedAthlete"].ToString();
                string uname = userName;
                return true;
            }
            else
            {
                if (Session["role"].ToString() == "athlete")
                {
                    return false;
                }
                else
                {
                    
                    
                    FirebaseService firebaseService = new FirebaseService();
                    Dictionary<string,AthleteCoachConnection> connections = firebaseService.GetData <Dictionary<string,AthleteCoachConnection>>("AthleteCoachConnections");
                    foreach(KeyValuePair<string,AthleteCoachConnection> connection in connections)
                    {
                        AthleteCoachConnection conn = connection.Value;
                        string s = Session["userName"].ToString();
                        string uname = userName;
                        if(conn.AthleteUserName == userName && conn.CoachUserName == Session["userName"].ToString())
                        {
                            return true;
                        }
                    }
                }
                
            }
            return false;
        }
        public static List<Workout> GetRelevantWorkouts(string date,HttpSessionState Session)
        {

            FirebaseService firebaseService = new FirebaseService();

            List<Workout> workouts = new List<Workout>();
            Dictionary<string, Workout> allWorkouts = firebaseService.GetData<Dictionary<string, Workout>>($"Activities/{GetUserAccessToken(Session)}");

            foreach (KeyValuePair<string, Workout> workoutKVP in allWorkouts)
            {
                Workout workout = workoutKVP.Value;
                if (workout.WorkoutDate.Replace(" ", "") == date)
                {
                    workouts.Add(workout);
                }
            }

            return workouts;
        }

        public static string GetUserAccessToken(HttpSessionState Session)
        {

            FirebaseService firebaseService = new FirebaseService();
            GarminData userData = firebaseService.GetData<GarminData>($"GarminData/{Session["requestedAthlete"]}");
            return userData.userAccessToken;

        }


        public static string GetUserAccessTokenByUserName(string userName)
        {
            FirebaseService firebaseService = new FirebaseService();


            GarminData userData = firebaseService.GetData<GarminData>($"GarminData/{userName}");
            return userData.userAccessToken;


        }


        public static Workout GetWorkoutByUATAndID(string userAccessToken , string activityId)=> new FirebaseService()
                                                                                                .GetData<Workout>($"Activities/{userAccessToken}/{activityId}");
        public static string GetUserAccessToken(string userName)
        {

            FirebaseService firebaseService = new FirebaseService();
            GarminData userData = firebaseService.GetData<GarminData>($"GarminData/{userName}");
            return userData.userAccessToken;

        }

        public static string ConvertMinutesToTimeString(float minutes)
        {
            // Convert the float minutes to total seconds
            int totalSeconds = (int)(minutes * 60);

            // Calculate minutes and seconds
            int mm = totalSeconds / 60;
            int ss = totalSeconds % 60;

            // Return formatted string in mm:ss format
            return $"{mm:D2}:{ss:D2}";
        }

        public static bool IsLoggedIn(HttpSessionState sessionState) => sessionState["userName"] != null;

        public static double PaceToSpeed(string pace)
        {
            if (string.IsNullOrWhiteSpace(pace)) throw new ArgumentException("Pace cannot be null or empty.");

            string[] parts = pace.Split(':');
            if (parts.Length != 2 || !int.TryParse(parts[0], out int minutes) || !int.TryParse(parts[1], out int seconds))
            {
                throw new FormatException("Invalid pace format. Expected mm:ss.");
            }

            double totalSecondsPerKm = minutes * 60 + seconds;
            return 1000 / totalSecondsPerKm; // Speed in m/s
        }



        public static bool IsGarminConnected(string userName) => new FirebaseService().GetData<GarminData>($"GarminData/{userName}") != null;
        
        

    }
}