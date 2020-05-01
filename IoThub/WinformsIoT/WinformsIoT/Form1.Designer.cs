namespace WinformsIoT
{
    partial class ControlarServos
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
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.btnAizq = new System.Windows.Forms.Button();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.btnAder = new System.Windows.Forms.Button();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.btnUder = new System.Windows.Forms.Button();
            this.btnUizq = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.SuspendLayout();
            // 
            // textBox1
            // 
            this.textBox1.BackColor = System.Drawing.Color.Black;
            this.textBox1.ForeColor = System.Drawing.Color.Lime;
            this.textBox1.Location = new System.Drawing.Point(12, 59);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(417, 229);
            this.textBox1.TabIndex = 1;
            this.textBox1.TextChanged += new System.EventHandler(this.textBox1_TextChanged);
            // 
            // btnAizq
            // 
            this.btnAizq.Location = new System.Drawing.Point(24, 39);
            this.btnAizq.Name = "btnAizq";
            this.btnAizq.Size = new System.Drawing.Size(62, 35);
            this.btnAizq.TabIndex = 2;
            this.btnAizq.Text = "<<";
            this.btnAizq.UseVisualStyleBackColor = true;
            this.btnAizq.Click += new System.EventHandler(this.btnAizq_Click);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.btnAder);
            this.groupBox1.Controls.Add(this.btnAizq);
            this.groupBox1.Location = new System.Drawing.Point(435, 166);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(176, 91);
            this.groupBox1.TabIndex = 3;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Servo Abajo";
            // 
            // btnAder
            // 
            this.btnAder.Location = new System.Drawing.Point(92, 39);
            this.btnAder.Name = "btnAder";
            this.btnAder.Size = new System.Drawing.Size(64, 35);
            this.btnAder.TabIndex = 3;
            this.btnAder.Text = ">>";
            this.btnAder.UseVisualStyleBackColor = true;
            this.btnAder.Click += new System.EventHandler(this.btnAder_Click);
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.btnUder);
            this.groupBox2.Controls.Add(this.btnUizq);
            this.groupBox2.Location = new System.Drawing.Point(435, 69);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(176, 91);
            this.groupBox2.TabIndex = 4;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Servo Arriba";
            // 
            // btnUder
            // 
            this.btnUder.Location = new System.Drawing.Point(92, 39);
            this.btnUder.Name = "btnUder";
            this.btnUder.Size = new System.Drawing.Size(64, 35);
            this.btnUder.TabIndex = 3;
            this.btnUder.Text = ">>";
            this.btnUder.UseVisualStyleBackColor = true;
            this.btnUder.Click += new System.EventHandler(this.btnUder_Click);
            // 
            // btnUizq
            // 
            this.btnUizq.Location = new System.Drawing.Point(24, 39);
            this.btnUizq.Name = "btnUizq";
            this.btnUizq.Size = new System.Drawing.Size(62, 35);
            this.btnUizq.TabIndex = 2;
            this.btnUizq.Text = "<<";
            this.btnUizq.UseVisualStyleBackColor = true;
            this.btnUizq.Click += new System.EventHandler(this.btnUizq_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.Red;
            this.label1.Location = new System.Drawing.Point(12, 24);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(193, 17);
            this.label1.TabIndex = 5;
            this.label1.Text = "Dispositivo desconectado";
            this.label1.Visible = false;
            // 
            // ControlarServos
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(623, 300);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.textBox1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "ControlarServos";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Controlar Servos";
            this.Load += new System.EventHandler(this.ControlarServos_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox2.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.Button btnAizq;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Button btnAder;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.Button btnUder;
        private System.Windows.Forms.Button btnUizq;
        private System.Windows.Forms.Label label1;
    }
}

