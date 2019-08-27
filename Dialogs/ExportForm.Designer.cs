﻿namespace FLIMage.Dialogs
{
    partial class ExportForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(ExportForm));
            this.ZProjectionCheckBox = new System.Windows.Forms.CheckBox();
            this.NoProjection = new System.Windows.Forms.CheckBox();
            this.MaxProc = new System.Windows.Forms.RadioButton();
            this.SumProc = new System.Windows.Forms.RadioButton();
            this.SaveButton = new System.Windows.Forms.Button();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.SaveChannel4 = new System.Windows.Forms.CheckBox();
            this.SaveChannel3 = new System.Windows.Forms.CheckBox();
            this.SaveChannel2 = new System.Windows.Forms.CheckBox();
            this.SaveChannel1 = new System.Windows.Forms.CheckBox();
            this.ProjectionBox = new System.Windows.Forms.GroupBox();
            this.AllFiles = new System.Windows.Forms.CheckBox();
            this.FastZGroup = new System.Windows.Forms.GroupBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.LastSlice = new System.Windows.Forms.TextBox();
            this.StartSlice = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.Row = new System.Windows.Forms.TextBox();
            this.Column = new System.Windows.Forms.TextBox();
            this.CorrectT0EachPageCheck = new System.Windows.Forms.CheckBox();
            this.groupBox1.SuspendLayout();
            this.ProjectionBox.SuspendLayout();
            this.FastZGroup.SuspendLayout();
            this.SuspendLayout();
            // 
            // ZProjectionCheckBox
            // 
            this.ZProjectionCheckBox.AutoSize = true;
            this.ZProjectionCheckBox.Location = new System.Drawing.Point(36, 83);
            this.ZProjectionCheckBox.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.ZProjectionCheckBox.Name = "ZProjectionCheckBox";
            this.ZProjectionCheckBox.Size = new System.Drawing.Size(158, 29);
            this.ZProjectionCheckBox.TabIndex = 2;
            this.ZProjectionCheckBox.Text = "Z-projection";
            this.ZProjectionCheckBox.UseVisualStyleBackColor = true;
            // 
            // NoProjection
            // 
            this.NoProjection.AutoSize = true;
            this.NoProjection.Checked = true;
            this.NoProjection.CheckState = System.Windows.Forms.CheckState.Checked;
            this.NoProjection.Location = new System.Drawing.Point(36, 38);
            this.NoProjection.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.NoProjection.Name = "NoProjection";
            this.NoProjection.Size = new System.Drawing.Size(102, 29);
            this.NoProjection.TabIndex = 5;
            this.NoProjection.Text = "Slices";
            this.NoProjection.UseVisualStyleBackColor = true;
            // 
            // MaxProc
            // 
            this.MaxProc.AutoSize = true;
            this.MaxProc.Checked = true;
            this.MaxProc.Location = new System.Drawing.Point(266, 62);
            this.MaxProc.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.MaxProc.Name = "MaxProc";
            this.MaxProc.Size = new System.Drawing.Size(84, 29);
            this.MaxProc.TabIndex = 6;
            this.MaxProc.TabStop = true;
            this.MaxProc.Text = "Max";
            this.MaxProc.UseVisualStyleBackColor = true;
            // 
            // SumProc
            // 
            this.SumProc.AutoSize = true;
            this.SumProc.Location = new System.Drawing.Point(266, 104);
            this.SumProc.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.SumProc.Name = "SumProc";
            this.SumProc.Size = new System.Drawing.Size(86, 29);
            this.SumProc.TabIndex = 7;
            this.SumProc.Text = "Sum";
            this.SumProc.UseVisualStyleBackColor = true;
            // 
            // SaveButton
            // 
            this.SaveButton.Location = new System.Drawing.Point(410, 567);
            this.SaveButton.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.SaveButton.Name = "SaveButton";
            this.SaveButton.Size = new System.Drawing.Size(188, 52);
            this.SaveButton.TabIndex = 9;
            this.SaveButton.Text = "Save";
            this.SaveButton.UseVisualStyleBackColor = true;
            this.SaveButton.Click += new System.EventHandler(this.SaveButton_Click);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.SaveChannel4);
            this.groupBox1.Controls.Add(this.SaveChannel3);
            this.groupBox1.Controls.Add(this.SaveChannel2);
            this.groupBox1.Controls.Add(this.SaveChannel1);
            this.groupBox1.Location = new System.Drawing.Point(18, 23);
            this.groupBox1.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Padding = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.groupBox1.Size = new System.Drawing.Size(452, 144);
            this.groupBox1.TabIndex = 12;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Save Channel";
            // 
            // SaveChannel4
            // 
            this.SaveChannel4.AutoSize = true;
            this.SaveChannel4.Location = new System.Drawing.Point(266, 75);
            this.SaveChannel4.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.SaveChannel4.Name = "SaveChannel4";
            this.SaveChannel4.Size = new System.Drawing.Size(142, 29);
            this.SaveChannel4.TabIndex = 17;
            this.SaveChannel4.Text = "Channel 4";
            this.SaveChannel4.UseVisualStyleBackColor = true;
            // 
            // SaveChannel3
            // 
            this.SaveChannel3.AutoSize = true;
            this.SaveChannel3.Location = new System.Drawing.Point(266, 37);
            this.SaveChannel3.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.SaveChannel3.Name = "SaveChannel3";
            this.SaveChannel3.Size = new System.Drawing.Size(142, 29);
            this.SaveChannel3.TabIndex = 16;
            this.SaveChannel3.Text = "Channel 3";
            this.SaveChannel3.UseVisualStyleBackColor = true;
            // 
            // SaveChannel2
            // 
            this.SaveChannel2.AutoSize = true;
            this.SaveChannel2.Location = new System.Drawing.Point(50, 75);
            this.SaveChannel2.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.SaveChannel2.Name = "SaveChannel2";
            this.SaveChannel2.Size = new System.Drawing.Size(142, 29);
            this.SaveChannel2.TabIndex = 15;
            this.SaveChannel2.Text = "Channel 2";
            this.SaveChannel2.UseVisualStyleBackColor = true;
            // 
            // SaveChannel1
            // 
            this.SaveChannel1.AutoSize = true;
            this.SaveChannel1.Location = new System.Drawing.Point(50, 37);
            this.SaveChannel1.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.SaveChannel1.Name = "SaveChannel1";
            this.SaveChannel1.Size = new System.Drawing.Size(142, 29);
            this.SaveChannel1.TabIndex = 14;
            this.SaveChannel1.Text = "Channel 1";
            this.SaveChannel1.UseVisualStyleBackColor = true;
            // 
            // ProjectionBox
            // 
            this.ProjectionBox.Controls.Add(this.SumProc);
            this.ProjectionBox.Controls.Add(this.MaxProc);
            this.ProjectionBox.Controls.Add(this.NoProjection);
            this.ProjectionBox.Controls.Add(this.ZProjectionCheckBox);
            this.ProjectionBox.Location = new System.Drawing.Point(18, 179);
            this.ProjectionBox.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.ProjectionBox.Name = "ProjectionBox";
            this.ProjectionBox.Padding = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.ProjectionBox.Size = new System.Drawing.Size(452, 156);
            this.ProjectionBox.TabIndex = 13;
            this.ProjectionBox.TabStop = false;
            this.ProjectionBox.Text = "Projection";
            // 
            // AllFiles
            // 
            this.AllFiles.AutoSize = true;
            this.AllFiles.Location = new System.Drawing.Point(24, 517);
            this.AllFiles.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.AllFiles.Name = "AllFiles";
            this.AllFiles.Size = new System.Drawing.Size(357, 29);
            this.AllFiles.TabIndex = 8;
            this.AllFiles.Text = "All files with the same basename";
            this.AllFiles.UseVisualStyleBackColor = true;
            // 
            // FastZGroup
            // 
            this.FastZGroup.Controls.Add(this.label3);
            this.FastZGroup.Controls.Add(this.label4);
            this.FastZGroup.Controls.Add(this.LastSlice);
            this.FastZGroup.Controls.Add(this.StartSlice);
            this.FastZGroup.Controls.Add(this.label2);
            this.FastZGroup.Controls.Add(this.label1);
            this.FastZGroup.Controls.Add(this.Row);
            this.FastZGroup.Controls.Add(this.Column);
            this.FastZGroup.Location = new System.Drawing.Point(18, 350);
            this.FastZGroup.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.FastZGroup.Name = "FastZGroup";
            this.FastZGroup.Padding = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.FastZGroup.Size = new System.Drawing.Size(520, 156);
            this.FastZGroup.TabIndex = 14;
            this.FastZGroup.TabStop = false;
            this.FastZGroup.Text = "Fast Z Slices";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(264, 90);
            this.label3.Margin = new System.Windows.Forms.Padding(6, 0, 6, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(103, 25);
            this.label3.TabIndex = 7;
            this.label3.Text = "Last slice";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(264, 42);
            this.label4.Margin = new System.Windows.Forms.Padding(6, 0, 6, 0);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(107, 25);
            this.label4.TabIndex = 6;
            this.label4.Text = "Start slice";
            // 
            // LastSlice
            // 
            this.LastSlice.Location = new System.Drawing.Point(378, 87);
            this.LastSlice.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.LastSlice.Name = "LastSlice";
            this.LastSlice.Size = new System.Drawing.Size(96, 31);
            this.LastSlice.TabIndex = 5;
            // 
            // StartSlice
            // 
            this.StartSlice.Location = new System.Drawing.Point(378, 37);
            this.StartSlice.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.StartSlice.Name = "StartSlice";
            this.StartSlice.Size = new System.Drawing.Size(96, 31);
            this.StartSlice.TabIndex = 4;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(34, 92);
            this.label2.Margin = new System.Windows.Forms.Padding(6, 0, 6, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(54, 25);
            this.label2.TabIndex = 3;
            this.label2.Text = "Row";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(22, 42);
            this.label1.Margin = new System.Windows.Forms.Padding(6, 0, 6, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(85, 25);
            this.label1.TabIndex = 2;
            this.label1.Text = "Column";
            // 
            // Row
            // 
            this.Row.Location = new System.Drawing.Point(116, 87);
            this.Row.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.Row.Name = "Row";
            this.Row.Size = new System.Drawing.Size(96, 31);
            this.Row.TabIndex = 1;
            // 
            // Column
            // 
            this.Column.Location = new System.Drawing.Point(116, 37);
            this.Column.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.Column.Name = "Column";
            this.Column.Size = new System.Drawing.Size(96, 31);
            this.Column.TabIndex = 0;
            // 
            // CorrectT0EachPageCheck
            // 
            this.CorrectT0EachPageCheck.AutoSize = true;
            this.CorrectT0EachPageCheck.Checked = true;
            this.CorrectT0EachPageCheck.CheckState = System.Windows.Forms.CheckState.Checked;
            this.CorrectT0EachPageCheck.Location = new System.Drawing.Point(24, 558);
            this.CorrectT0EachPageCheck.Margin = new System.Windows.Forms.Padding(6);
            this.CorrectT0EachPageCheck.Name = "CorrectT0EachPageCheck";
            this.CorrectT0EachPageCheck.Size = new System.Drawing.Size(283, 29);
            this.CorrectT0EachPageCheck.TabIndex = 15;
            this.CorrectT0EachPageCheck.Text = "Correct T0 for each page";
            this.CorrectT0EachPageCheck.UseVisualStyleBackColor = true;
            // 
            // ExportForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(12F, 25F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(626, 648);
            this.Controls.Add(this.CorrectT0EachPageCheck);
            this.Controls.Add(this.FastZGroup);
            this.Controls.Add(this.AllFiles);
            this.Controls.Add(this.ProjectionBox);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.SaveButton);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Margin = new System.Windows.Forms.Padding(6, 6, 6, 6);
            this.Name = "ExportForm";
            this.Text = "Export file in TIFF ...";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.ExportForm_FormClosing);
            this.Load += new System.EventHandler(this.ExportForm_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ProjectionBox.ResumeLayout(false);
            this.ProjectionBox.PerformLayout();
            this.FastZGroup.ResumeLayout(false);
            this.FastZGroup.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.CheckBox ZProjectionCheckBox;
        private System.Windows.Forms.CheckBox NoProjection;
        private System.Windows.Forms.RadioButton MaxProc;
        private System.Windows.Forms.RadioButton SumProc;
        private System.Windows.Forms.Button SaveButton;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.GroupBox ProjectionBox;
        private System.Windows.Forms.CheckBox AllFiles;
        private System.Windows.Forms.CheckBox SaveChannel2;
        private System.Windows.Forms.CheckBox SaveChannel1;
        private System.Windows.Forms.CheckBox SaveChannel4;
        private System.Windows.Forms.CheckBox SaveChannel3;
        private System.Windows.Forms.GroupBox FastZGroup;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox Row;
        private System.Windows.Forms.TextBox Column;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox LastSlice;
        private System.Windows.Forms.TextBox StartSlice;
        private System.Windows.Forms.CheckBox CorrectT0EachPageCheck;
    }
}