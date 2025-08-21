<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ChangeProfilePic.aspx.cs" Inherits="GooseNet.ChangeProfilePic" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>GooseNet - Change Profile Picture</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #1f2937, #111827);
            color: white;
        }
        .glass-panel {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
        }
        .file-input-label {
            display: inline-block;
            padding: 12px 24px;
            cursor: pointer;
            background: #60a5fa; /* Tailwind's blue-400 */
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-align: center;
        }
        .file-input-label:hover {
            background: #3b82f6; /* Tailwind's blue-500 */
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
        }
        input[type="file"] {
            display: none;
        }
        .btn-primary {
            background: #38bdf8; /* Tailwind's sky-400 */
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background: #0ea5e9; /* Tailwind's sky-500 */
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(14, 165, 233, 0.4);
        }
        .btn-revert {
            background: #f43f5e; /* Tailwind's rose-500 */
            transition: all 0.3s ease;
        }
        .btn-revert:hover {
            background: #e11d48; /* Tailwind's rose-600 */
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(225, 29, 72, 0.4);
        }
        .profile-pic-preview {
            border-radius: 50%;
            width: 100px;
            height: 100px;
            object-fit: cover;
            border: 3px solid white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mx-auto px-6 flex items-center justify-center min-h-screen">
        <div class="max-w-lg w-full">
            <h1 class="text-4xl md:text-5xl font-extrabold mb-8 text-center" style="text-shadow: 0 4px 20px rgba(0,0,0,0.2);">
                Account Management
            </h1>

            <!-- Change Profile Picture Panel -->
            <div class="glass-panel p-6 md:p-8 rounded-3xl shadow-2xl">
                <h2 class="text-3xl font-bold mb-6 text-center">Change Profile Picture</h2>

                <div class="flex flex-col items-center space-y-6">
                    <!-- Current Profile Picture -->
                    <div class="text-center">
                        <p class="text-gray-300 text-sm mb-2">Current Profile Picture</p>
                        <center><img class="profile-pic-preview" src="<%=Session["picString"].ToString() %>" alt="Current Profile Picture" /></center>
                    </div>

                    <!-- Revert to Default Button -->
                    <a href="HandlePicChange.aspx?revertToDefault=true" class="btn-revert text-white font-semibold py-3 px-6 rounded-xl w-full text-center">
                        Revert to Default Profile Picture
                    </a>

                    <!-- Separator -->
                    <div class="w-full h-px bg-gray-600/50 my-4"></div>

                    <!-- New Profile Picture Form -->
                    <form id="imageForm" action="HandlePicChange.aspx" method="POST" class="w-full flex flex-col items-center space-y-6">
                        <p class="text-gray-300 text-sm">Choose New Profile Picture from your Device</p>

                        <!-- Preview of the new image -->
                        <img id="imageShow" class="profile-pic-preview hidden" src="#" alt="New Profile Picture Preview" />

                        <!-- File input and button to select file -->
                        <label for="fileInput" class="file-input-label text-white font-semibold w-full">
                            Choose File
                        </label>
                        <input type="file" id="fileInput" accept="image/*">
                        
                        <input type="hidden" name="base64Output" id="imageBase64">

                        <!-- Submit button -->
                        <button type="submit" class="btn-primary text-white font-semibold py-3 px-6 rounded-xl w-full">
                            Submit
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        // JavaScript to handle the file input and image preview
        document.getElementById('fileInput').addEventListener('change', function (event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function () {
                    document.getElementById('imageBase64').value = reader.result;
                    document.getElementById('imageShow').src = reader.result;
                    document.getElementById('imageShow').classList.remove('hidden');
                };
                reader.readAsDataURL(file);
            }
        });
    </script>
</asp:Content>
