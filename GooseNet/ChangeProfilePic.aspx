<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ChangeProfilePic.aspx.cs" Inherits="GooseNet.ChangeProfilePic" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
      form {
    position: relative;
    width: fit-content;
    background-color: rgba(255,255,255,0.13);
    margin: auto;
    top: initial;
    left: initial;
    transform: none;
    border-radius: 10px;
    backdrop-filter: blur(10px);
    border: 2px solid rgba(255,255,255,0.1);
    box-shadow: 0 0 40px rgba(8,7,16,0.6);
    padding: 5vw 20vh;
}

    input[type=file]{
       color:white
    }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  
    <center>
    <h1>Current Profile Picture:</h1>
    <img  style="border-radius:50%;width:100px;height:100px;border:3px solid white;" src="<%=Session["picString"].ToString() %>"<br />
                <br /><br /><button><a href="HandlePicChange.aspx?revertToDefault=true">Revert To Default Profile Picture</a></button>

    <h2>Choose New Profile Picture from your Device</h2>

         <form id="imageForm" action="HandlePicChange.aspx" method="POST">
        <input type="file" id="fileInput" accept="image/*">
        <input  type="hidden" name="base64Output" id="imageBase64">
             <img  style="border-radius:50%;width:100px;height:100px;border:3px solid white;" width="100" id="imageShow"/>
        <button type="submit">Submit</button>
    </form>

    <script>
        document.getElementById('imageShow').style.display = 'none';
        document.getElementById('fileInput').addEventListener('change', function(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function() {
                    document.getElementById('imageBase64').value = reader.result;
                    document.getElementById('imageShow').src = reader.result;

                    document.getElementById('imageShow').style.display = 'block';

                };
                reader.readAsDataURL(file);
            }
        });
    </script>
        </center>
</asp:Content>
