<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="GooseNet.Register" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        input[type=radio] {
    border: 0px;
    width: 100%;
    height: 2em;
}
        option,select{
          color:black;
        }
        form{

        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

     <form id="formWithDesign"action="HandleRegister.aspx" method="post">
           <h3>Register Here</h3>
         <%HandleUserNameTakenError(); %>
        <label for="fullName">Full Name:</label>
        <input type="text" id="fullName" name="fullName" required><br><br>

        <label for="userName">Username:</label>
        <input type="text" id="userName" name="userName" required><br><br>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required><br><br>

        <label for="role">Select Role:</label>
        <select id="role" name="role" required>
            <option value="coach">Coach</option>
            <option value="athlete">Athlete</option>
        </select><br><br>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>
         <canvas  style="display:none;"id="letterCanvas" width="200" height="200"></canvas>
         <textarea  name="picString" style="display:none;" id="base64Output"></textarea>
            <button id="formButton" type="button" >Register</button>
    </form>
         
    <script>
        function getRandomColor() {
            const letters = '0123456789ABCDEF';
            let color = '#';
            for (let i = 0; i < 6; i++) {
                color += letters[Math.floor(Math.random() * 16)];
            }
            return color;
        }

        function drawLetter(letter, bgColor) {
            const canvas = document.getElementById("letterCanvas");
            const ctx = canvas.getContext("2d");

            // Background color
            ctx.fillStyle = bgColor;
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            // Letter styling
            ctx.font = "100px Arial";
            ctx.fillStyle = "white";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";

            // Draw the letter in the center
            ctx.fillText(letter, canvas.width / 2, canvas.height / 2);

            // Update the Base64 textarea
            const base64Data = canvas.toDataURL("image/png");
            document.getElementById("base64Output").value = base64Data;
        }

        function generateLetterImage() {
            const name = document.getElementById("userName").value.trim();
            if (name.length === 0) {
                alert("Please enter a name.");
                return;
            }

            const firstLetter = name.charAt(0).toUpperCase();
            const randomBgColor = getRandomColor();
            drawLetter(firstLetter, randomBgColor);
        }

        document.getElementById('formButton').addEventListener('click', () => {

            generateLetterImage();
            document.forms[0].submit();
        });
    </script>
</asp:Content>
