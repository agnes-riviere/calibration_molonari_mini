Experimental protocol for calibration of pressure sensors
=====================


# 1. **Objectives 
The hydraulic head gradient between a point in the riverbed and the river is measured using pressure transducers. A membrane inside the pressure transducer bends in response to the pressures on either side of it. A membrane-enclosed electrical circuit converts the membrane's curvature into an electrical voltage U. The temperature T of the membrane affects the measured voltage U as well.


Therefore, it is necessary to establish the relationship between measured voltage, differential pressure, and temperature in order to convert the electrical voltage measured in the field into differential pressure. For every sensor, this relationship is different. The experimental procedure used to collect the measurements required for this calibration is described in this document's paragraphs 2 through 4, along with the steps taken to process the data and determine the calibration coefficients.
# 2.  **Introduction to the experiments
For each sensor, it is necessary to perform at least:

* One voltage-differential pressure calibration (Part 3);
* Three constant water level calibrations, which can be performed outdoors or in a climate chamber (Part 4).

The name of the pressure transducers (p505, etc.) is indicated on each transducer on a scotch tape.

The files related to the calibration are saved in the calibration_molonari_mini/data folder. The hobo and csv files contain the experiment records and are saved in files corresponding to the different sensors. These files also contain the Excel files of the U-H calibrations.

The data from the experiments are then integrated into the calibration_molonari_mini/data/1_raw_data/ folder, which in addition to the data from the experiments detailed in this protocol file contains the post-processing scripts, figures, and calibration coefficients, the final goal of these experiments. 

**It is important to follow the steps precisely to allow for efficient data processing afterwards.

**
# 3. **Voltage - Pressure Differential Calibration
The voltage - differential pressure calibration is done on a calibration ramp. It consists in establishing the relation between differential pressure and measured voltage, for a constant temperature.

![1.jpg](Aspose.Words.b00ec4d5-1e5d-479a-9442-4939d53b6ee2.001.jpeg) Figure 1 - Experimental set-up for the calibration of pressure sensors.

## Materials required

- The pressure sensor to be calibrated, in its box. Be sure to check the name of the pressure sensor, which is indicated on a tape on the pressure sensor (and not on the box containing the pressure sensor);
- A Hobo;
- The wooden board;
- The field computer and the USB cable to connect the Hobo to the computer;
- A funnel.

## Experimental protocol
### Hoboware setup
The date must be formatted in Month Day Year (see Figure 2)

![IMG_3944.jpg](IMG_3944.jpg) Figure 2 - Hoboware software date configuration.

The units must be in international system (See Figure 3)

![IMG_3942.jpg](IMG_3942.jpg) Figure 3 - Configuration of the Hoboware software units


### Preparation
  1. Install the wooden board vertically, connect the tubes of the wooden board to the outlets of the box (see Figure 1).
  2. Connect the 2 small tubes of the pressure sensor to the connectors on the box. To do this, fill each tube with water using the syringe, being careful not to leave any air bubbles in the tubes. Then push the tubes into the connectors.
  3. Add about 10 cm of water to each of the tubes on the wooden board. Use the funnel to help you. It is necessary to start with the same height of water in both tubes (right and left).
  4. Launch the Hoboware software. Connect the Hobo to the computer with the USB cable.
  5. Check the battery status of the Hobo by going to "Device Status". If the battery is too low (below 50%), change the battery of the Hobo or change the Hobo.
  6. From the Hoboware software, start the pressure and temperature recording (two recording channels out of 4 are used). The pressure sensor must be on channel 1 and named "voltage" and the temperature sensor must be on channel 2 and named "temperature." To do this, go to Peripheral > Launch. Select a time step of 30 seconds for the recording (see Figure 4).
 
 
![IMG_3947.jpg](IMG_3947.jpg) Figure 4 - Hobos configuration for calibration
 
  7. Record the names of the tubes on the sensor (right and left). 
  8. Create a calibration Excel file and name it [SensorName]\_calibUH, for example, p505\_calibUH. Save it in Dcalibration_molonari_mini/data/1_raw_data/. The first column of this file will contain the water levels in the left tube. The second column will contain the water levels in the right tube. The third column will contain the water level differential, the convention is "right minus left" (column B - column A). The fourth column will contain the voltages measured by the Hobo.


 

### Calibration

Before starting the calibration, make sure that the recording of temperatures and voltages has been started (Step 6 of preparation). While the recording is running, display the "Device Status" window.

1. Enter the water level in the left column and the water level in the right column in the Excel file. The third column, defined by column A, must contain the load difference.
2. Wait for the voltage measured by the pressure sensor to stabilize (this voltage is displayed in the Device Status window). Then transfer it to the fourth column.
3. Add water to the left-hand column. 
4. Repeat from point 1.
5. As long as the voltage sensor has not reached saturation, repeat these steps every 5 mm between 0 and 5 cm, every 1 cm between 5 and 15 cm, and finally every 5 cm between 15 cm. 6. Follow these same instructions on the opposite side to calibrate the device from tablecloth to river and from river to tablecloth. Change "left" to "right" in point b after the sensor has reached saturation, then repeat the change until you reach the second plateau of saturation. Create an Excel graph that plots the measured voltage against the difference in water height after a few points have been made (column D against column C). As you proceed, use this graph to make sure the points are plotted in a straight line.


7. At the end of the calibration
  a. Verify that the recording has been stopped before removing it from the hobo (Device > Playback). Save the Hobo recordings as a.hobo file in the same calibration LOMOS mini/data/1 raw data/ [sensorName] folder as the Excel calibration file. The file should be named [sensorname] calibUH.hobo. On the pressure sensor, a tape with the sensor's name is visible (not on the box containing it).
  
  b. Export the hobo's data measurements to a csv file. To do this:
  
  b1. Open the Hobo file with Hoboware with File > Open data file
 
 b2. Export by doing File > Export Table Data, click on Export, and select "csv" as file type. Keep the same name as the hobo file.
 
 c. Update the etalSensorsPress Excel document by adding the date of the experiment and the person's name.
 d. Replace the etalSensorsPress Excel file with the new version.
 e. Add the hobo, csv and Excel calibration files to the corresponding sensor folder. 
# 4. Voltage-temperature calibration At constant differential pressure, the relationship between measured voltage and temperature variation is established using voltage-temperature calibrations. A climatic chamber calibration method and an outdoor calibration method have both been developed. The two paragraphs that follow provide descriptions of them. The method used in the climate chamber is preferred because it enables temperature control of the surrounding air.

***The metadata related to each U-T calibration must be reported in an Excel dashboard.** A reference version named pxxx\_YYYY-mm-dd\_UTxxxxxxxx\_Dashboard is available in the folder 1\_raw\_data/modele. Replace the first field of xxx by the corresponding sensor number, the field YYYY-mm-dd by the start date of the experiment, and the last field xxxxx by "room" or "outside".
 ## 4.1. **Calibration in the climatic chamber
In comparison to calibration outside, the climatic chamber offers the advantage of being able to control the ambient temperature; however, while operating, the climatic chamber vibrates and muffles the measured voltage signal.


**Important note:** Prepare the device the day before, measure the water heights, and start the environmental chamber only the next day to prevent the first experiment from being invalidated because the pipes are deformed.




### Necessary equipment

* The calibrated pressure sensor in its box Make sure to verify the pressure sensor's name, which is written on a tape attached to the device (not on the box housing the device);
* A Hobo ;
* The field computer with: 
  * the USB cable to connect the Hobo to the computer;
  * a screwdriver to open the pressure sensor boxes. 
* A toolbox with :
  * A cutter
  * A syringe and its tip
  * A voltmeter
  * Batteries for the Hobo 
* Two pieces of 16 mm diameter pipe, each about 20 cm long;
* A string, two necklaces, 2 earplugs (see Figure 2);
- A large blue box to cover the device outside.
 ### Experimental protocol

 #### Preparation**

1. Copy the model file (data / 1\_raw\_data / modele / pxxx\_YYYY-mm-dd\_UTxxxxxxxx\_chart.xlsx) into the corresponding sensor folder (data / 1\_raw\_data / pxxx\_YYYY-mm-dd\_calibUH / pxxx\_YYYY-mm-dd\_UTChambre\_rampe\_chart).
2. In the file name, change the xxx (eg. p509\_2016-07-08\_UTChambre\_rampe\_tableauDeBord).
3. Open the Excel file, the 1st tab. There are three experiments to complete. Each experiment corresponds to a pressure differential, indicated in the column "target differential".
4. Prepare the sensor for the 1st experiment (see the experimental protocol described in "experimental protocol" in paragraph 4.2). **Start the hobo with a time step of 1min**.
5. Fill in the water heights on both sides of the sensor, having in mind the target differential.
6. Place the sensor in the climate chamber.
7. Record the water level on the river side and on the hyporheic zone side and transfer them to the Excel file. Check that the estimated differential is close to the target differential.
8. Fill in the date and name columns.
9. Close the climate chamber and run the program containing a ramp from 25 to 5°C in 6 hours and a second ramp going the opposite way.
10. Retrieving the data


  a.  Measure the water heights in the tubes when the environmental chamber is opened and add them to the Excel table before moving the sensors. Repeat the experiment if the heights have changed too much. otherwise, keep reading:
  
  b. Launch the Hoboware software.
  
  c. Connect the Hobo to the computer. 
  
  d.Check that the recording has ended before removing it from the Hobo (Device > Playback). In the same folder as the Excel calibration file, save the Hobo recordings on the field computer as a.hobo file: *data / 1\_raw\_data / [sensorName]*. 
  
  e. Name the file *[sensorname]\_calibUT\_[experiment number].hobo*. Note that the name of the sensor is indicated on a tape on the pressure sensor. The number of the experiment is indicated on the Excel sheet *etalSensorsPress\_logbook*.
  
  f. Export the data measured by the hobo to a csv file. To do this:
  
  g. Open the hobo file with Hoboware with File > Open Data File
  
  h. Export by doing File > Export Table Data, click on Export, and select "csv" as the file type. Keep the same name as the hobo file.
  
  i.  Update the Excel file *etalCapteursPress\_tableauDeBord* by adding the date of the experiment and the name of the person.
  
  
11. Repeat these steps for the other two pressure differentials.

When all 3 experiments have been completed, proceed to the steps in REF 4.3.
 ## 4.2. **Outdoor calibration
CTo benefit from the differences in temperature between day and night, calibration is carried out outside. Each calibration has a desired load differential value (deviating from this target value by a few mm is not a problem, see 1.e). The Excel document contains the target values.*etalCapteursPress\_tableauDeBord*.

### Time needed

Allow 2h-2h30. It is more efficient to run several calibrations at the same time, what takes time is mainly the preparation of the equipment.








### Materials needed

1. The pressure sensor to be calibrated, in its box. Make sure to check the name of the pressure sensor, which is indicated on a tape on the pressure sensor (not on the box containing the pressure sensor);
2. A Hobo ;
3. The field computer with
  * the USB cable to connect the Hobo to the computer;
  * a screwdriver to open the pressure sensor boxes.
4. A toolbox with :
  * A cutter
  * A syringe and its tip
  * A voltmeter
  * Batteries for the Hobo
5. Two pieces of pipe, each about 20 cm long;
6. - A string, two necklaces, 2 earplugs (see Figure 2);
7. A large blue box to cover the device outside.

### Experimental protocol

1. Start the recording
2. Fill in the Excel document *etalCapteursPress\_tableauDeBord* : in the box corresponding to the sensor treated, write the date of the beginning of the experiment and the name(s) of the person(s) doing the manipulation. 
3. Check the batteries of the pressure sensor using the voltmeter. They must be at 7.5V (±1V).
4. Connect the branches of the sensor to the cable glands. To do this, fill each small branch with water using the syringe, being careful not to leave any air bubbles in the tubes. Then push the small tubes into the glands.
5. Connect the 2 pieces of tubing to the glands on the outside of the box. 
6. Attach the clamps to the top of each pipe, connect the two pipes with a string, so that the device looks like the one in REF \_Ref430347103 \h Figure 2. Make sure that the device goes under the blue box that will cover the device outside. 
7. Add about ten centimeters of water to each tube.
8. Check the battery status of the Hobo. If there is no battery in the hobo, put some in. Change the battery or the Hobo if the battery is less than 80% charged.
9. Connect the Hobo to the pressure sensor. Channel 1 is pressure, channel 2 is temperature. Two out of four recording channels are used.
10. From the Hoboware software, launch the pressure and temperature recording. To do this, go to Peripherals > Launch. Channel 1 is the pressure (Stereo cable 0-2.5V), channel 2 is the temperature (). Uncheck channels 3 and 4. Select a *time step of **15 minutes*** for recording.


11. Disconnect the Hobo from the computer, place the pressure sensor + Hobo device outside the hall, according to Figure 2. 
12. Fill in the water heights in each of the tubes until you reach a difference approximately equal to the target value indicated in the Excel document *etalCapteursPress\_tableDeBord*. Plug the tubes with the earplugs to prevent detritus from entering the tubes.

13. Complete the Excel document *etalCapteursPress\_tableauDeBord*: in the box corresponding to the sensor treated, enter the measured water heights, and check that the calculated height differential is close to the target value.

Leave the recording for <b>3-4 days</b>.

14. Recovery of registration
* Switch on the field computer and launch the Hoboware software.
* Connect the Hobo to the computer.
* Pull recording from hobo (Device > Playback), confirming stop recording. Save Hobo recordings on the field computer in a .hobo file, in the same folder as the calibration Excel file: *data/1\_raw\_data/[sensorname]*. Name the file *[sensor name]\_caliBUT\_[experiment number].hobo*. Attention, the name of the sensor is indicated on a tape on the pressure sensor. The experiment number is indicated on the Excel sheet *etalCapteursPress\_tableauDeBord*.


  * Export the data measured by the hobo to a csv file. To do this:
    * Open the hobo file with Hoboware with File > Open a data file
    * Export by doing File > Export Table Data, click on Export, and select "csv" as file type. Keep the same name as the hobo file.
    * Add the hobo and csv files to the sensor folder.

![](Aspose.Words.b00ec4d5-1e5d-479a-9442-4939d53b6ee2.002.jpeg "IMG\_9007")

Figure 2 - Experimental setup for voltage-temperature calibration at constant load differential.




# 5.  Following the voltage-temperature calibration
1. Fill in the sensor monitoring file Suivi_capteurs\_pression.xlsx, located in the svn data-hz/Avenelles/raw\_data/DESC\_data/DATA\_SENSOR/capteurs\_pression :
2.  In the tab calibrations, fill the type of calibration carried out for the sensor;
3.  In the tab corresponding to the calibrated sensor, report the details of the calibrations and possibly the anomalies found during the recordings.
4.  In the folder /data/1\_raw\_data/pxxx/pxxx\_YYYY-etc, make sure that there are :
 * the .hobo files of the recordings ;
  * the Excel file for the dashboard with the 1st tab completely filled in.

# 7. **Data formatting
For both types of calibration (voltage-differential charge and voltage-temperature), the recordings are contained in hobo files. They must therefore be converted into csv files that can be read by the R scripts.

1. For each of the .hobo files, in Hoboware, do File > Export Table Data ... Save the csv in the same folder as the corresponding hobo file, and keep the same file name (only the extension changes from .hobo to .csv).

2. For voltage-load calibrations:

 * Transform the Excel file into a csv file readable by R scripts. As described in paragraph 3, the 3rd column must contain the load differential, and the 4th column must contain the corresponding measured voltage. 
 * Transform the .hobo record file into a .csv file. The name of the recording file must end with "\_recording.csv".

![](Aspose.Words.b00ec4d5-1e5d-479a-9442-4939d53b6ee2.003.png)

Figure 3 - Files corresponding to the voltage-charge calibration for the p506 sensor. The script 1\_rawToFormatted.R reads the 2 .csv files.

3. For the voltage-temperature calibrations, a few additional steps are required.

   * In the csv file, remove the parts of the record that do not correspond to the experiment (e.g., in the climate chamber, remove what was recorded outside the operation of the chamber).
   * Report the load differentials in a new tab of the Excel document, opposite the name of the corresponding record file (see Figure 4). If the record must be ignored for some reason, indicate "invalid" in place of the load differential. Then export this tab as a csv file, with the name "dashboard". It is important to do this step correctly, because it is this file that is then read by the scripts.
   * Once these different steps have been carried out, launch the R script 1\_rawToFormatted.R which reads the different data files and puts everything in a homogenized form, in the folder 2\_formatted\_data.

![](Aspose.Words.b00ec4d5-1e5d-479a-9442-4939d53b6ee2.004.png)

Figure 4 - Carryover of load differentials for each of the U-T records in the 2nd tab of the file p505\_2016-08\_UTChambre\_rampe\_tableauDeBord.xlsx. Each row corresponds to a record: column A contains the corresponding file name, column B contains the applied load differential. This tab must then be saved in csv format, it will be read by the script 1\_rawToFormatted.R.

![](Aspose.Words.b00ec4d5-1e5d-479a-9442-4939d53b6ee2.005.png)

Figure 5 - Example of the files corresponding to the climate chamber experiment at the end of the steps in paragraph 5.1. The files read by the script R 1\_rawToFormatted.R is the set of csv files.

# 7. **Manual pre-processing**
At the end of the script 1\_rawToFormatted.R all the data are saved in the folder 2\_data\_formatted, in a homogenized form. It is now possible to make some modifications to the data, if necessary. Several types of modifications can be considered:

The problematic portion of the record can be manually removed, or the record can be truncated, if there is a problem. Plots created with 0 plot raw.R are intended to assist with this step. 
 In this case, record the manual alterations in a text file with the name modifications.txt that was saved in the same directory as the formatted data. 
 Save the updated information in a file bearing the same name but prefixed with "_modif."
Filte the climate chamber signal that was captured. For each temperature slope, a linear regression of the recorded voltage is computed. The linear regression function in the script 2 filterClimaticChamber can be used. The file names end with "flt.csv" after this step. 5. Correct the offset offsets between the U-T curves and the U-H calibration curve.


# 8. calculation of calibration curvesR scripts then process the data gathered during the calibrations described above to determine the relationship between the measured voltage, the applied differential load, and the temperature. The [README.md](README.md) provides information on the various processing steps. This paragraph goes into detail about the recordings' post-processing. All of the files pertaining to the calibration of the sensors can be found in the calibration folder. The raw data are saved in the calibration/data/1 raw data folder, as was previously mentioned. The scripts are in the calibration/scripts R directory.


The R scripts perform the calculations. The various processing steps up until the calibration coefficients are obtained are described in the [README.® (README.®). The calibration/calib folder contains the calibration coefficients.
