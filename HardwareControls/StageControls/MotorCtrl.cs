﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace FLIMage.HardwareControls.StageControls
{
    public class MotorCtrl
    {
        MotorCtrl_MP285A mp285a;
        ThorMCMX000 thorMCMX000;
        MotorCtrl_ThorMCM3001 thorMCM3001;

        public event MotorHandler MotH;
        public MotrEventArgs e = new MotrEventArgs("");
        public delegate void MotorHandler(MotorCtrl mCtrls, MotrEventArgs e);


        object controller_object;

        public double maxDistanceXY = 500; //micrometers
        public double maxDistanceZ = 100;

        public int N_Coordinate = 3;

        public double XPos, YPos, ZPos;
        public double XRefPos, YRefPos, ZRefPos;
        public double XNewPos, YNewPos, ZNewPos;

        public double XPos_um, YPos_um, ZPos_um;
        public double XRelPos_um, YRelPos_um, ZRelPos_um;

        public int AllowError = 5;

        public double XYStep, ZStep;
        public double XRelPos, YRelPos, ZRelPos;

        public double minMotorVal = -Math.Pow(2, 31) + 1;

        public double resolutionX; //=0.04     
        public double resolutionY; //=0.04
        public double resolutionZ; //=0.005

        public double[] velocity = new double[3];
        public double[] maxVelocity = new double[3];
        public double[] minVelocity = new double[3];
        public bool setting_velocity = false;

        public double ZStack_Stepsize = 1;
        public int ZStack_nSlices = 1;
        public double ZStackStart = int.MaxValue;
        public double ZStackCenter = int.MaxValue;
        public double ZStackEnd = int.MaxValue;

        //public int ZStackStart_rel, ZStack_End_rel;
        public MotorCtrl.DeviceMode device_mode;
        public bool waitingReturn = false;

        public bool freezing = false;

        public bool continuous_read = true;
        public bool connected = true;


        public MotorTypeEnum MotorType;
        public String tString;//

        public MotorCtrl.StackPosition stack_Position = MotorCtrl.StackPosition.Undefined;

        public bool continuous_readCheck = true;
        public int MotorDisplayUpdateTime_ms = 1000;


        public MotorCtrl(String MotorType_in, String Comport, double[] resolution, double[] velocity, double[] steps, int motorDisplayUpdateTime)
        {
            MotorDisplayUpdateTime_ms = motorDisplayUpdateTime;
            if (MotorType_in == "MP-285" || MotorType_in == "MP285")
            {
                MotorType = MotorTypeEnum.mp285a;
                mp285a = new MotorCtrl_MP285A(Comport, resolution, (int)velocity[0], false, MotorDisplayUpdateTime_ms);

                connected = mp285a.connected;
                if (mp285a.connected)
                {
                    mp285a.MotH += new MotorCtrl_MP285A.MotorHandler(MotorListenerA);
                    resolution = mp285a.GetResolution();
                    controller_object = mp285a;
                }
            }
            else if (MotorType_in == "MP-285A" || MotorType_in == "MP285A")
            {
                MotorType = MotorTypeEnum.mp285a;
                mp285a = new MotorCtrl_MP285A(Comport, resolution, (int)velocity[0], true, MotorDisplayUpdateTime_ms);
                connected = mp285a.connected;
                if (mp285a.connected)
                {
                    mp285a.MotH += new MotorCtrl_MP285A.MotorHandler(MotorListenerA);
                    resolution = mp285a.GetResolution();
                    controller_object = mp285a;
                }
            }
            else if (MotorType_in == "ThorMCM3000" || MotorType_in == "ThorMCM5000")
            {
                MotorType = MotorTypeEnum.thorMCM3000;
                if (MotorType_in == "ThorMCM5000")
                    MotorType = MotorTypeEnum.thorMCM5000;

                thorMCMX000 = new ThorMCMX000(resolution, MotorType, MotorDisplayUpdateTime_ms);
                connected = thorMCMX000.connected;
                if (connected)
                {
                    thorMCMX000.MotH += new ThorMCMX000.MotorHandler(MotorListenerThorX000);
                    resolution = thorMCMX000.GetResolution();
                    controller_object = thorMCMX000;
                }
            }
            else if (MotorType_in.Contains("MCM300") || MotorType_in.Contains("BScope"))
            {
                MotorType = MotorTypeEnum.thorMCM3001;
                thorMCM3001 = new MotorCtrl_ThorMCM3001(Comport, resolution, MotorType_in, MotorDisplayUpdateTime_ms);
                connected = thorMCM3001.connected;
                if (connected)
                {
                    thorMCM3001.MotH += new MotorCtrl_ThorMCM3001.MotorHandler(MotorListenerThor3001);
                    resolution = thorMCM3001.GetResolution();
                    controller_object = thorMCM3001;
                }
            }

            if (controller_object == null)
                connected = false;

            resolutionX = resolution[0];
            resolutionY = resolution[1];
            resolutionZ = resolution[2];

            GetPosition();
            Zero_All();

            XYStep = steps[0];
            ZStep = steps[2];
        }

        public void MotorListenerA(MotorCtrl_MP285A m, MotrEventArgs e)
        {
            getParameters();
            MotH?.Invoke(this, e);
        }

        public void MotorListenerThorX000(ThorMCMX000 th, MotrEventArgs e)
        {
            getParameters();
            MotH?.Invoke(this, e);
        }

        public void MotorListenerThor3001(MotorCtrl_ThorMCM3001 th, MotrEventArgs e)
        {
            getParameters();
            MotH?.Invoke(this, e);
        }

        public void getPos()
        {
            var XYZ = (double[])controller_object.GetType().GetMethod("GetCurrentUncalibratedPosition").Invoke(controller_object, null);
            XPos = XYZ[0];
            YPos = XYZ[1];
            ZPos = XYZ[2];
        }

        public void getNewPos()
        {
            var XYZ = (double[])controller_object.GetType().GetMethod("GetNewPosition").Invoke(controller_object, null);
            XNewPos = XYZ[0];
            YNewPos = XYZ[1];
            ZNewPos = XYZ[2];
        }

        public void getVelocity()
        {
            if (MotorType == MotorTypeEnum.mp285a)
            {
                velocity[0] = mp285a.velocity_coarse;
                maxVelocity[0] = mp285a.maxVelocity;
                minVelocity[0] = mp285a.minVelocity;
                tString = mp285a.tString;
            }
            else
            {
                tString = (String)controller_object.GetType().GetField("tString").GetValue(controller_object);
            }
            //else
            //{
            //    velocity = (double[])controller_object.GetType().GetField("velocity").GetValue(controller_object);
            //    maxVelocity = (double[])controller_object.GetType().GetField("maxVelocity").GetValue(controller_object);
            //    minVelocity = (double[])controller_object.GetType().GetField("minVelocity").GetValue(controller_object);
            //    tString = (String)controller_object.GetType().GetField("tString").GetValue(controller_object);
            //}
        }


        public void getParameters()
        {
            getPos();
            getNewPos();
            getVelocity();
        }


        public void continuousRead(bool on)
        {
            continuous_readCheck = on;
            controller_object.GetType().GetField("continuous_readCheck").SetValue(controller_object, on);
        }


        public double[] convertToUncalibratedPosition(double[] XYZ, bool absolute)
        {
            double[] UncalibratedPosition = new double[3];
            if (absolute)
            {
                UncalibratedPosition[0] = (XYZ[0] / resolutionX);
                UncalibratedPosition[1] = (XYZ[1] / resolutionY);
                UncalibratedPosition[2] = (XYZ[2] / resolutionZ);
            }
            else
            {
                UncalibratedPosition[0] = (XYZ[0] / resolutionX + XRefPos);
                UncalibratedPosition[1] = (XYZ[1] / resolutionY + YRefPos);
                UncalibratedPosition[2] = (XYZ[2] / resolutionZ + ZRefPos);
            }
            return UncalibratedPosition;
        }

        public double[] getCalibratedRelativePosition()
        {
            getParameters();
            XRelPos = XPos - XRefPos;
            YRelPos = YPos - YRefPos;
            ZRelPos = ZPos - ZRefPos;

            XRelPos_um = XRelPos * resolutionX;
            YRelPos_um = YRelPos * resolutionY;
            ZRelPos_um = ZRelPos * resolutionZ;
            return new double[] { XRelPos_um, YRelPos_um, ZRelPos_um };
        }

        public double[] getCalibratedAbsolutePosition()
        {
            getParameters();

            XPos_um = XPos * resolutionX;
            YPos_um = YPos * resolutionY;
            ZPos_um = ZPos * resolutionZ;
            return new double[] { XPos_um, YPos_um, ZPos_um };
        }

        public double[] CurrentUncalibratedPosition()
        {
            getParameters();
            return new double[] { XPos, YPos, ZPos };
        }

        public void GotoStartPosition(bool warning_on, bool waitUntilFinish)
        {
            if (ZStackStart == int.MaxValue || ZStackEnd == int.MaxValue)
                return;

            double[] position = CurrentUncalibratedPosition();
            position[2] = ZStackStart;
            SetNewPosition(position);
            if (!IfStepTooBig(warning_on))
                SetPosition();

            if (waitUntilFinish) //For external command it will be always true.
            {
                WaitUntilMovementDone();
            }

            stack_Position = MotorCtrl.StackPosition.Start;
            GetPosition();
        }

        public void GotoEndPosition(bool warning_on, bool waitUntilFinish)
        {
            double[] position = CurrentUncalibratedPosition();
            position[2] = ZStackEnd;
            SetNewPosition(position);
            if (!IfStepTooBig(warning_on))
                SetPosition();

            if (waitUntilFinish) //For external command it will be always true.
            {
                WaitUntilMovementDone();
            }

            stack_Position = MotorCtrl.StackPosition.Start;
            GetPosition();
        }

        public void MoveMotorBackToCenter_RelativeToZStart()
        {
            double Z_um = (int)((double)(ZStack_nSlices - 1) * ZStack_Stepsize / resolutionZ / 2.0);
            GotoRelativeToZStart(true, true, Z_um);
            stack_Position = MotorCtrl.StackPosition.Start;
        }

        public void GotoRelativeToZStart(bool warning_on, bool waitUntilFinish, double Z_um)
        {
            double[] position = CurrentUncalibratedPosition();
            position[2] = ZStackStart + Z_um;
            SetNewPosition(position);
            if (!IfStepTooBig(warning_on))
                SetPosition();

            if (waitUntilFinish) //For external command it will be always true.
            {
                WaitUntilMovementDone();
            }
            GetPosition();
        }

        public void Zero_Z()
        {
            GetPosition();
            ZRefPos = ZPos;
        }

        public void Zero_All()
        {
            GetPosition();
            XRefPos = XPos;
            YRefPos = YPos;
            ZRefPos = ZPos;
        }

        public void WaitUntilMovementDone()
        {
            controller_object.GetType().GetMethod("WaitUntilMovementDone").Invoke(controller_object, null);
        }

        public void GetStatus()
        {
            if (MotorType == MotorTypeEnum.mp285a)
            {
                mp285a.GetStatus();
                velocity[0] = mp285a.velocity_coarse;
            }
            getParameters();
        }

        public void GetPosition()
        {
            try
            {
                controller_object.GetType().GetMethod("GetPosition").Invoke(controller_object, null);
            }
            catch (Exception ex)
            {
                Debug.WriteLine("MotorCtrl.GetPosition Invocation error: " + ex);
            }
            //if (block || MotorType == MotorTypeEnum.thorMCM3000 || MotorType == MotorTypeEnum.thorMCM5000)
            getParameters();
        }

        public bool IfStepTooBig(bool warningOn)
        {
            getParameters();
            double maxStepXY = maxDistanceXY;
            double maxStepZ = maxDistanceZ;

            double StepSizeX = Math.Abs(XNewPos - XPos) * resolutionX;
            double StepSizeY = Math.Abs(YNewPos - YPos) * resolutionY;
            double StepSizeZ = Math.Abs(ZNewPos - ZPos) * resolutionZ;

            if ((StepSizeZ > maxStepZ || StepSizeX > maxStepXY || StepSizeY > maxStepXY) && warningOn)
            {
                DialogResult dr;
                if (StepSizeZ > maxStepZ)
                    dr = MessageBox.Show("Moving a big step of " + StepSizeZ + "um in Z, Are you sure?", "", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
                else if (StepSizeY > maxStepXY)
                    dr = MessageBox.Show("Moving a big step of " + StepSizeY + "um in Y, Are you sure?", "", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
                else
                    dr = MessageBox.Show("Moving a big step of " + StepSizeX + "um in X, Are you sure?", "", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);

                if (dr == DialogResult.No)
                    return true;
                else
                    return false;
            }
            else
                return false;
        }

        /// <summary>
        /// This command send start-movement command to the device.
        /// It is required to set new position first.
        /// </summary>
        public void SetPosition()
        {
            controller_object.GetType().GetMethod("SetPosition").Invoke(controller_object, null);
        }

        public void MoveMotor(bool warningOn, bool waitUntilFinish)
        {
            if (waitUntilFinish)
                WaitUntilMovementDone(); //make sure that there is no task remaining.

            //this.Enabled = false;
            IfStepTooBig(warningOn);

            SetPosition(); //Actual movement.

            if (waitUntilFinish) //For external command it will be always true.
            {
                WaitUntilMovementDone();
                GetPosition();
            }
        }

        public void CalcNSlices(double stepSize)
        {            
            int nSlices = (int)Math.Ceiling(Math.Abs((ZStackStart - ZStackEnd) * resolutionZ / stepSize)) + 1;
            if (ZStackStart - ZStackEnd > 0)
                stepSize = -Math.Abs(stepSize);
            else
                stepSize = Math.Abs(stepSize);

            ZStack_Stepsize = stepSize;
            ZStack_nSlices = nSlices;
        }

        public void SetTopPosition()
        {
            GetPosition();
            double[] position = CurrentUncalibratedPosition();
            ZStackStart = position[2];
            ZStackCenter = ZStackStart + ZStackHalfStroke();
            ZStackEnd = ZStackStart + 2 * ZStackHalfStroke();
            stack_Position = MotorCtrl.StackPosition.Start;
            CalcNSlices(ZStack_Stepsize);
            ZStackCenter = ZStackStart + ZStackHalfStroke();
        }

        public void SetCenterPosition()
        {
            AutoCalculateStackStartEnd();
            stack_Position = MotorCtrl.StackPosition.Center;
        }

        public void SetBottomPosition()
        {
            if (ZStackStart == minMotorVal)
                MessageBox.Show("Please choose Start position first");
            else
            {
                GetPosition();
                double[] position = CurrentUncalibratedPosition();
                ZStackEnd = position[2];
                stack_Position = MotorCtrl.StackPosition.End;
                CalcNSlices(ZStack_Stepsize);
                ZStackCenter = ZStackStart + ZStackHalfStroke();
            }
        }

        public double ZStackHalfStroke()
        {
            return (double)(ZStack_nSlices - 1) * ZStack_Stepsize / resolutionZ / 2.0;
        }

        bool MotorStackCondition()
        {
            return (ZStack_nSlices > 1 && ZStack_Stepsize != 0) ;
        }

        public void MoveMotorBackToStart()
        {
            if (MotorStackCondition())// && motorCtrl.stack_Position != MotorCtrl.stackPosition.Start)
            {
                if (minMotorVal != ZStackStart)
                {
                    double[] current = CurrentUncalibratedPosition();
                    current[2] = ZStackStart;
                    SetNewPosition(current);
                    stack_Position = MotorCtrl.StackPosition.Start;
                    MoveMotor(false, true);
                }
            }
        }

        public void MoveMotorFromCenterToStart()
        {
            if (MotorStackCondition())
            {
                double[] current = CurrentUncalibratedPosition();
                ZStackCenter = current[2];
                current[2] = current[2] - ZStackHalfStroke();
                ZStackStart = current[2]; //Actually we should use calibrated value.. but anyway...
                ZStackEnd = ZStackStart + ZStackHalfStroke() * 2;

                SetNewPosition(current);
                stack_Position = MotorCtrl.StackPosition.Start;

                MoveMotor(false, true);
            }
        }

        public void AutoCalculateStackStartEnd()
        {
            double[] current = CurrentUncalibratedPosition();
            if (current[2] != 0)
            {
                ZStackStart = current[2] - ZStackHalfStroke();
                ZStackCenter = current[2];
                ZStackEnd = current[2] + ZStackHalfStroke();
            }
        }

        /// <summary>
        /// Set velocity.
        /// </summary>
        /// <param name="value"></param>
        public void SetVelocity(double[] value)
        {
            velocity = value;
            if (MotorType == MotorTypeEnum.mp285a)
            {
                mp285a.SetVelocity((int)value[0]);
            }
            //else if (MotorType == MotorTypeEnum.thorMCM3000 || MotorType == MotorTypeEnum.thorMCM5000) //NOT implemented yet.
            //{
            //    thorMCMX000.SetVelocity(value);
            //}
        }

        /// <summary>
        /// Just to set the new position after movement.
        /// Requries to execute "setPosition()" command to start motor movement.
        /// </summary>
        /// <param name="post_movementXYZ"></param>
        public void SetNewPosition(double[] post_movementXYZ)
        {
            controller_object.GetType().GetMethod("SetNewPosition").Invoke(controller_object, new object[] { post_movementXYZ });
        }

        /// <summary>
        /// Calculate from stepping.
        /// </summary>
        /// <param name="Stepsize_um"></param>
        public void SetNewPosition_StepSize_um(double[] Stepsize_um)
        {
            double[] currentXYZ = CurrentUncalibratedPosition();
            double[] movementXYZ = new double[3];
            movementXYZ[0] = currentXYZ[0] + Stepsize_um[0] / resolutionX;
            movementXYZ[1] = currentXYZ[1] + Stepsize_um[1] / resolutionY;
            movementXYZ[2] = currentXYZ[2] + Stepsize_um[2] / resolutionZ;
            SetNewPosition(movementXYZ);
        }

        public void reopen()
        {
            controller_object.GetType().GetMethod("reopen").Invoke(controller_object, null);
        }

        public void unsubscribe()
        {
            controller_object.GetType().GetMethod("unsubscribe").Invoke(controller_object, null);
        }


        public enum MotorTypeEnum
        {
            mp285a = 1,
            thorMCM3000 = 2,
            thorMCM3001 = 3,
            thorMCM5000 = 4,
        }

        public enum DeviceMode
        {
            fine = 1,
            coarse = 2,
        }

        public enum StackPosition
        {
            Start = 1,
            End = 2,
            Center = 3,
            Undefined = 4,
            InStack = 5,
        }
    }

    public class MotrEventArgs : EventArgs
    {
        public string Name { get; set; }
        public MotrEventArgs(string Name)
        {
            this.Name = Name;
        }
    }
}
