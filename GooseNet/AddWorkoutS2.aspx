<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AddWorkoutS2.aspx.cs" Inherits="GooseNet.AddWorkoutS2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

  
        <div>
        <form method="post" action="PostWorkout.aspx?intervals=<%=Request.QueryString["intervals"].ToString() + "&athleteName="  +  Request.QueryString["athleteName"].ToString()  %>" style="margin-bottom:100px;" id="workoutForm" style="top:50%">
            <h3>Insert Workout Details</h3>
         Workout Name(Emojis Are Recomended):<br />
        <input name="workoutName" type="text"/><br /><br />
         <textarea name="workoutDescription" rows="20" cols="60" style="resize:none;"></textarea><br /><br />
          <input name="workoutDate" type="date" /><br /><br />
       <%-- <div class="interval">
            <h3>Interval {i+1}</h3>
            Duration Value Type:<br /><br />

            <select name="intervalDurationType{i}">

                <option value="minutes">Minutes</option>
                <option value="seconds">Seconds</option>
                <option value="meters">Meters</option>
                <option value="kilometers">kilometers</option>

            </select><br /><br />
            Interval Duration Value:
            <input name="intervalDurationValue{i}" /> <br /><br />
            Interval Pace:<br />
            <input class="paceInput" type="number" name="intervalPaceMinutes{i}"  placeholder="Minutes"/>:<input class="paceInput" type="number" name="intervalPaceSeconds" placeholder="Seconds"/>
        </div>--%>
            <%=GenerateIntervalHTML() %>
            <br />
            <button type="submit">Submit</button>
            </form>
        </div>
  

    
    <script>
        function getParameterByName(name, url = window.location.href) {
            name = name.replace(/[\[\]]/g, '\\$&');
            var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, ' '));
        }
        let intervalAmount = getParameterByName('intervals');
        document.getElementById('workoutForm').style.marginTop = (intervalAmount * 10).toString() + "%";
    </script>
</asp:Content>
