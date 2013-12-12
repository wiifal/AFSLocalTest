using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace FirstApp
{
    public partial class mainForm : Form
    {
        public mainForm()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (lstList.SelectedIndex != -1)
            {
                txtText.Text = "This is a source control." + lstList.Items[lstList.SelectedIndex].ToString();
            }
        }

        private void label1_Click(object sender, EventArgs e)
        {
            lblOne.Text = "Clicked!:";
        }

        private void chkColorChange_CheckedChanged(object sender, EventArgs e)
        {
            if (chkColorChange.Checked == true)
            {
                txtText.ForeColor = Color.Red;
                label1_Click(sender, e);
            }
            else
            {
                txtText.ForeColor = Color.Black;
            }
        }
    }
}
