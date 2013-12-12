namespace FirstApp
{
    partial class mainForm
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
            this.dateTimePicker1 = new System.Windows.Forms.DateTimePicker();
            this.button1 = new System.Windows.Forms.Button();
            this.txtText = new System.Windows.Forms.TextBox();
            this.lblOne = new System.Windows.Forms.Label();
            this.lstList = new System.Windows.Forms.ListBox();
            this.chkColorChange = new System.Windows.Forms.CheckBox();
            this.SuspendLayout();
            // 
            // dateTimePicker1
            // 
            this.dateTimePicker1.Location = new System.Drawing.Point(35, 35);
            this.dateTimePicker1.Name = "dateTimePicker1";
            this.dateTimePicker1.Size = new System.Drawing.Size(343, 22);
            this.dateTimePicker1.TabIndex = 0;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(268, 204);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(110, 49);
            this.button1.TabIndex = 1;
            this.button1.Text = "Press me!";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // txtText
            // 
            this.txtText.Location = new System.Drawing.Point(126, 63);
            this.txtText.Name = "txtText";
            this.txtText.Size = new System.Drawing.Size(252, 22);
            this.txtText.TabIndex = 2;
            // 
            // lblOne
            // 
            this.lblOne.AutoSize = true;
            this.lblOne.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblOne.Location = new System.Drawing.Point(32, 66);
            this.lblOne.Name = "lblOne";
            this.lblOne.Size = new System.Drawing.Size(88, 17);
            this.lblOne.TabIndex = 3;
            this.lblOne.Text = "New Label:";
            this.lblOne.Click += new System.EventHandler(this.label1_Click);
            // 
            // lstList
            // 
            this.lstList.FormattingEnabled = true;
            this.lstList.ItemHeight = 16;
            this.lstList.Items.AddRange(new object[] {
            "One",
            "Two",
            "Three",
            "Four",
            "Five",
            "Six",
            "Seven",
            "Eight",
            "Nine",
            "Ten"});
            this.lstList.Location = new System.Drawing.Point(35, 105);
            this.lstList.Name = "lstList";
            this.lstList.Size = new System.Drawing.Size(137, 148);
            this.lstList.TabIndex = 4;
            this.lstList.UseTabStops = false;
            // 
            // chkColorChange
            // 
            this.chkColorChange.AutoSize = true;
            this.chkColorChange.Location = new System.Drawing.Point(262, 105);
            this.chkColorChange.Name = "chkColorChange";
            this.chkColorChange.Size = new System.Drawing.Size(116, 21);
            this.chkColorChange.TabIndex = 5;
            this.chkColorChange.Text = "Change Color";
            this.chkColorChange.UseVisualStyleBackColor = true;
            this.chkColorChange.CheckedChanged += new System.EventHandler(this.chkColorChange_CheckedChanged);
            // 
            // mainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(401, 291);
            this.Controls.Add(this.chkColorChange);
            this.Controls.Add(this.lstList);
            this.Controls.Add(this.lblOne);
            this.Controls.Add(this.txtText);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.dateTimePicker1);
            this.Name = "mainForm";
            this.Text = "GitSample";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DateTimePicker dateTimePicker1;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.TextBox txtText;
        private System.Windows.Forms.Label lblOne;
        private System.Windows.Forms.ListBox lstList;
        private System.Windows.Forms.CheckBox chkColorChange;
    }
}

