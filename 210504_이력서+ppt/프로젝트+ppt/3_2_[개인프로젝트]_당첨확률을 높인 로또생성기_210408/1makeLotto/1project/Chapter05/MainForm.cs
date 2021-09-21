using Chapter05.cont;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Chapter05
{
    public partial class MainForm : Form
    {
        Handler hd = new Handler();
        const string HINTED_TEXT = "확률무시 랜덤생성 수";
        public MainForm()
        {
            InitializeComponent();
            initLabelText();
            showHelp();
        }


        private void button_test_Click(object sender, EventArgs e)
        {
            try
            {
                if (makeRandTxtBox.Text == HINTED_TEXT)
                {
                    makeRandTxtBox.Text = "0";
                }

                int makeR = int.Parse(makeRandTxtBox.Text);
                if (makeR > 7 || makeR < 0)
                {
                    MessageBox.Show("0~7사이의 값을 입력하세요\n 0으로 다시 초기화합니다.");
                    makeRandTxtBox.Text = "0";
                    return;
                }
                hd.makeLotto(makeR);
            }
            catch (FormatException)
            {
                MessageBox.Show("유효하지 않은 값입니다.");
                makeRandTxtBox.Text = "0";
                return;
            }

            int[] gluck = hd.GoodLuck;
            Label[] labelNum = { label_num1, label_num2, label_num3, label_num4, label_num5, label_num6, label_num7 };
            Label[] thisPerc = { thisPcent_1, thisPcent_2, thisPcent_3, thisPcent_4, thisPcent_5, thisPcent_6, thisPcent_7 };
            PctTxtShowRed(thisPerc, gluck);
            changeLabel(labelNum, thisPerc, gluck);
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            if (makeRandTxtBox.Text == "")
            {
                makeRandTxtBox.Text = HINTED_TEXT;
                makeRandTxtBox.ForeColor = Color.Gray;
            }
        }

        private void makeRandTxtBox_Enter(object sender, EventArgs e)
        {
            if (makeRandTxtBox.Text.Length > 0)
            {
                makeRandTxtBox.Text = string.Empty;
                makeRandTxtBox.ForeColor = Color.Black;
            }
        }

        private void initLabelText()
        {
            Label[] labelNum = { label_num1, label_num2, label_num3, label_num4, label_num5, label_num6, label_num7 };
            Label[] thisPerc = { thisPcent_1, thisPcent_2, thisPcent_3, thisPcent_4, thisPcent_5, thisPcent_6, thisPcent_7 }; 
            PictureBox[] picBox = { gongImg_1, gongImg_2, gongImg_3, gongImg_4, gongImg_5, gongImg_6, gongImg_7 };
            for (int i = 0; i < thisPerc.Length; i++)
            {
                labelNum[i].Text = (i + 1).ToString();
                thisPerc[i].Text = "-";
            }


            for (int i = 0; i < labelNum.Length; i++) // 아래** 줄인 것
            {
                var pos = this.PointToScreen(labelNum[i].Location);
                pos = picBox[i].PointToClient(pos);
                labelNum[i].Parent = picBox[i];
                labelNum[i].Location = pos;
                labelNum[i].BackColor = Color.Transparent;
            }

            // 스택오버플로우 참고.. 라벨텍스트 배경색 투명으로  --> 1~7까지 숫자만 바꿔서 쳐야하는 코드**
            /*
            var pos1 = this.PointToScreen(label_num1.Location); 
            pos1 = gongImg_1.PointToClient(pos1);
            label_num1.Parent = gongImg_1;
            label_num1.Location = pos1;
            label_num1.BackColor = Color.Transparent;*/
        }

        private void showHelp() //msDOC 툴팁 내용 참고 
        {
            // Create the ToolTip and associate with the Form container.
            ToolTip tTip = new ToolTip();

            // Set up the delays for the ToolTip.
            tTip.AutoPopDelay = 6000;
            tTip.InitialDelay = 500;
            tTip.ReshowDelay = 15000;
            // Force the ToolTip text to be displayed whether or not the form is active.
            tTip.ShowAlways = false;


            // Set up the ToolTip text for the Button and Checkbox.
            tTip.SetToolTip(this.HelpLabelTxt, "[사용법]\n1. 랜덤생성할 수를 1~7사이의 값을 입력하세요.\n\n" +
                "2. 유효하지 않은 값 입력시 자동으로 랜덤생성 수는 \n  0으로 초기화(문자나 공백 등)\n\n" +
                "* 랜덤수가 0일때 기본값으로 전체회차의 \n  90%이상인 당첨번호가 랜덤생성 됩니다.\n\n" +
                "  최소 확률 : 70%, 최대 : 100%\n" +
                "  확률이 90%미만인 번호의 갯수 : 33");
        }

        private void PctTxtShowRed(Label[] thisPerc, int[] gluck)
        {
            for (int i = 0; i < gluck.Length; i++)
            {
                int hk = (int)(hd.hwaklyul(gluck[i]) * 100);
                if (hk < 90)
                {
                    thisPerc[i].ForeColor = Color.Red;
                }
                else
                {
                    thisPerc[i].ForeColor = Color.Black;
                }
            }
        }

        private void changeLabel(Label[] labelNum, Label[] thisPerc, int[] gluck)
        {
            for (int i = 0; i < labelNum.Length; i++)
            {
                labelNum[i].Text = gluck[i].ToString();
                thisPerc[i].Text = ((hd.hwaklyul(gluck[i])) * 100).ToString() + "%";
            }
        }
    }
}
