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
            txtText.Text = "Hello world sample. This is a source control." + lstLista.Items[lstLista.SelectedIndex].ToString();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }
    }
}
