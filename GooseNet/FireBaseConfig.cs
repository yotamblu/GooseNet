using FireSharp.Config;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GooseNet
{
    public class FireBaseConfig
    {

        public static FirebaseConfig config = new FirebaseConfig
        {
            AuthSecret = "E2xB8ulKJbdBd7ij8x49pJnnmA4PhLmLJdFSv0E4", // Your Firebase database secret
            BasePath = "https://testproj-20016-default-rtdb.europe-west1.firebasedatabase.app/" // Your Firebase Realtime Database URL
        };
    }
}