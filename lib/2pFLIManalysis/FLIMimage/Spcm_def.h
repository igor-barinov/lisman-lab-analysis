/*---------------------------------------------------------------------------*/
/*                              SPCM                                         */
/*---------------------------------------------------------------------------*/
/*    Copyright (c) Becker & Hickl GmbH  2000  All Rights Reserved.          */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/* Title   : SPCM_DEF.H                                                       */
/* Purpose : Include file for programs using SPC (PCI versions) 32-bit DLL   */
/*              under Windows95/NT.                                          */
/* Note    :                                                                 */
/*                                                                           */
/*   Functions listed here are exported in   spcm32.dll                      */
/*                                                                           */
/*   Use proper Import Library File spc_dll.lib depending on used compiler   */
/*    ( Borland C++ v.4 , Watcom C , Microsoft Visual C and  Symantec C      */
/*        compilers are supported )                                          */
/*                                                                           */
/*---------------------------------------------------------------------------*/

/*- Defines -----------------------------------------------------------------*/

#include <cvirte.h>     /* needed if linking DLL in external compiler; harmless otherwise */



#ifdef __cplusplus
  extern "C" {
#endif

#pragma pack(1)



#define MAX_NO_OF_SPC     8    /* max number of SPC modules controlled by DLL */

#ifndef SPC_DEFINITIONS
#define SPC_DEFINITIONS

#define OK                0    /* no error */

/*- Error codes  ------------------------------------------------------------*/
#define  SPCDLL_ERROR_KEYWORDS \
{ \
  keyword (SPC_NONE), \
  keyword (SPC_OPEN_FILE), \
  keyword (SPC_FILE_NVALID), \
  keyword (SPC_MEM_ALLOC), \
  keyword (SPC_READ_STR), \
  keyword (SPC_WRONG_ID), \
  keyword (SPC_EEPROM_CHKSUM), \
  keyword (SPC_EEPROM_READ), \
  keyword (SPC_EEPROM_WRITE), \
  keyword (SPC_EEP_WR_DIS), \
  keyword (SPC_BAD_PAR_ID), \
  keyword (SPC_BAD_PAR_VAL), \
  keyword (SPC_HARD_TEST), \
  keyword (SPC_BAD_PARA1), \
  keyword (SPC_BAD_PARA2), \
  keyword (SPC_BAD_PARA3), \
  keyword (SPC_BAD_PARA4), \
  keyword (SPC_BAD_PARA5), \
  keyword (SPC_BAD_PARA6), \
  keyword (SPC_BAD_PARA7), \
  keyword (SPC_CANT_ARM),\
  keyword (SPC_CANT_STOP),\
  keyword (SPC_INV_REPT),\
  keyword (SPC_NO_SEQ),\
  keyword (SPC_SEQ_RUN),\
  keyword (SPC_FILL_TOUT),\
  keyword (SPC_BAD_FUNC),\
  keyword (SPC_WINDRV_ERR),\
  keyword (SPC_NOT_INIT),\
  keyword (SPC_ERR_ID),\
  keyword (SPC_RATES_NOT_RDY),\
  keyword (SPC_NO_ACT_MOD),\
  keyword (SPC_MOD_NO), \
  keyword (SPC_NOT_ACTIVE), \
  keyword (SPC_IN_USE), \
  keyword (SPC_WINDRV_VER),\
  keyword (SPC_DMA_ERR),\
  keyword (SPC_LICENSE_ERR),\
  keyword (SPC_WRITE_STR),\
  keyword (SPC_MAX_STREAM),\
  keyword (SPC_XILINX_ERR),\
  keyword (SPC_DET_NFOUND),\
};
                   
/*
   use function SPC_get_error_string to get error string programmatically
   
   SPC_NONE            0       no error
   SPC_OPEN_FILE      -1       can't open file
   SPC_FILE_NVALID    -2       not valid configuration file
   SPC_MEM_ALLOC      -3       memory allocation error
   SPC_READ_STR       -4       file read error (string or binary)
   SPC_WRONG_ID       -5       wrong module id read from SPC
   SPC_EEP_CHKSUM     -6       wrong EEPROM checksum
   SPC_EEPROM_READ    -7       error during reading EEPROM
   SPC_EEPROM_WRITE   -8       error during writing to EEPROM
   SPC_EEP_WR_DIS     -9       write access to EEPROM denied
   SPC_BAD_PAR_ID     -10      unknown SPC parameter id 
   SPC_BAD_PAR_VAL    -11      wrong SPC parameter value  
   SPC_HARD_TEST      -12      SPC hardware test error 
   SPC_BAD_PARA1      -13      wrong value of 1st function parameter 
   SPC_BAD_PARA2      -14      wrong value of 2nd function parameter 
   SPC_BAD_PARA3      -15      wrong value of 3rd function parameter 
   SPC_BAD_PARA4      -16      wrong value of 4th function parameter 
   SPC_BAD_PARA5      -17      wrong value of 5th function parameter 
   SPC_BAD_PARA6      -18      wrong value of 6th function parameter 
   SPC_BAD_PARA7      -19      wrong value of 7th function parameter 
   SPC_CANT_ARM       -20      cannot arm SPC module 
   SPC_CANT_STOP      -21      cannot stop SPC module  
   SPC_INV_REPT       -22      invalid contents of repeat timer 
   SPC_NO_SEQ         -23      sequencer does not exist on the module
   SPC_SEQ_RUN        -24      cannot execute function when sequencer is running
   SPC_FILL_TOUT      -25      timeout during filling SPC memory
   SPC_BAD_FUNC       -26      function not available for the module or current mode
   SPC_WINDRV_ERR     -27      Error in WinDriver
   SPC_NOT_INIT       -28      SPC is not yet initialized or unknown module type
   SPC_ERR_ID         -29      Error ID is out of range
   SPC_RATES_NOT_RDY  -30      Rates values not ready yet
   SPC_NO_ACT_MOD     -31      No active modules - nothing was initialized
   SPC_MOD_NO         -32      module number out of range 
   SPC_NOT_ACTIVE     -33      can't execute function - module not active
   SPC_IN_USE         -34      Cannot initialize - SPC module already in use
   SPC_WINDRV_VER     -35      Incorrect WinDriver version
   SPC_DMA_ERR        -36      DMA Transfer Error           
   SPC_LICENSE_ERR    -37      Wrong or missing license key
   SPC_WRITE_STR      -38      can't write string to the file
   SPC_MAX_STREAM     -39      cannot open more than 8 streams of photon files
   SPC_XILINX_ERR     -40      Xilinx chip not configured - reduced SPC functionality
   SPC_DET_NFOUND     -41      Cannot find detector's Xilinx file
*/



/*- SPC parameters IDs ------------------------------------------------------*/

#define  SPC_PARAMETERS_KEYWORDS \
{ \
  keyword (CFD_LIMIT_LOW), \
  keyword (CFD_LIMIT_HIGH), \
  keyword (CFD_ZC_LEVEL), \
  keyword (CFD_HOLDOFF), \
  keyword (SYNC_ZC_LEVEL), \
  keyword (SYNC_FREQ_DIV), \
  keyword (SYNC_HOLDOFF), \
  keyword (SYNC_THRESHOLD), \
  keyword (TAC_RANGE), \
  keyword (TAC_GAIN), \
  keyword (TAC_OFFSET), \
  keyword (TAC_LIMIT_LOW), \
  keyword (TAC_LIMIT_HIGH), \
  keyword (ADC_RESOLUTION), \
  keyword (EXT_LATCH_DELAY), \
  keyword (COLLECT_TIME), \
  keyword (DISPLAY_TIME), \
  keyword (REPEAT_TIME), \
  keyword (STOP_ON_TIME), \
  keyword (STOP_ON_OVFL), \
  keyword (DITHER_RANGE), \
  keyword (COUNT_INCR), \
  keyword (MEM_BANK), \
  keyword (DEAD_TIME_COMP), \
  keyword (SCAN_CONTROL), \
  keyword (ROUTING_MODE), \
  keyword (TAC_ENABLE_HOLD), \
  keyword (MODE), \
  keyword (SCAN_SIZE_X), \
  keyword (SCAN_SIZE_Y), \
  keyword (SCAN_ROUT_X), \
  keyword (SCAN_ROUT_Y), \
  keyword (SCAN_POLARITY), \
  keyword (SCAN_FLYBACK), \
  keyword (SCAN_BORDERS), \
  keyword (PIXEL_TIME), \
  keyword (PIXEL_CLOCK), \
  keyword (LINE_COMPRESSION), \
  keyword (TRIGGER), \
  keyword (EXT_PIXCLK_DIV), \
  keyword (RATE_COUNT_TIME), \
  keyword (MACRO_TIME_CLK), \
  keyword (ADD_SELECT), \
  keyword (ADC_ZOOM), \
  keyword (XY_GAIN), \
  keyword (IMG_SIZE_X), \
  keyword (IMG_SIZE_Y), \
  keyword (IMG_ROUT_X), \
  keyword (IMG_ROUT_Y), \
  keyword (MASTER_CLOCK), \
  keyword (ADC_SAMPLE_DELAY), \
  keyword (DETECTOR_TYPE), \
  keyword (X_AXIS_TYPE), \
};                                   




#ifdef keyword
#undef keyword  /* prevents redefinition warning */
#endif

#define keyword(key) key

enum spcdll_error_enum     SPCDLL_ERROR_KEYWORDS
enum spc_parameters_enum   SPC_PARAMETERS_KEYWORDS

    /* rate values structure */
typedef struct _rate_values
{
  float sync_rate;
  float cfd_rate;
  float tac_rate;
  float adc_rate;

} rate_values;

#endif     // SPC_DEFINITIONS


/*---------------------------------------------------------------------------*/

      /* correct SPC modules id values - tested in SPC_test_id */
#define SPC400_ID               0x8

      /* possible modes of DLL operation - returned from SPC_set(get)_mode */
#define SPC_HARD             0      /* hardware mode */
#define SPC_SIMUL600         600    /* simulation mode of SPC600 module */
#define SPC_SIMUL630         630    /* simulation mode of SPC630 module */
#define SPC_SIMUL700         700    /* simulation mode of SPC700 module */
#define SPC_SIMUL730         730    /* simulation mode of SPC730 module */
#define SPC_SIMUL130         130    /* simulation mode of SPC130 module */
#define SPC_SIMUL830         830    /* simulation mode of SPC830 module */
#define SPC_SIMUL140         140    /* simulation mode of SPC140 module */
#define SPC_SIMUL930         930    /* simulation mode of SPC930 module */
#define DPC_SIMUL230         230    /* simulation mode of DPC230 module */

    /* supported module types  - returned value from SPC_test_id */
#define M_WRONG_TYPE  -1
#define M_SPC600    600   /* PCI version of 400 + 401 + 402 */  
#define M_SPC630    630   /* PCI version of 430 + 431 + 432 */  
#define M_SPC700    700   /* PCI version of 500 + 505 + 506 */  
#define M_SPC730    730   /* PCI version of 530 + 535 + 536 */  
#define M_SPC130    130   
#define M_SPC830    830   
#define M_SPC140    140   
#define M_SPC930    930   
#define M_DPC230    230   

         /* masks for SPC module state  - function SPC_test_state */
#define SPC_OVERFL       0x1     /* stopped on overflow */
#define SPC_OVERFLOW     0x2     /* overflow occured */
#define SPC_TIME_OVER    0x4     /* stopped on expiration of collection timer */
#define SPC_COLTIM_OVER  0x8     /* collection timer expired */
#define SPC_CMD_STOP     0x10    /* stopped on user command */
#define SPC_ARMED        0x80    /* measurement in progress (current bank) */
#define SPC_REPTIM_OVER  0x20    /* repeat timer expired */
#define SPC_COLTIM_2OVER 0x100   /* second overflow of collection timer */
#define SPC_REPTIM_2OVER 0x200   /* second overflow of repeat timer */
         /* masks valid only for modules SPC130, SPC6x0 */
#define SPC_SEQ_GAP      0x40    /* Sequencer is waiting for other bank to be armed */
         /* masks valid only for modules SPC130, SPC6x0, SPC830, SPC140, SPC930 */
#define SPC_FOVFL        0x400   /* Fifo overflow,data lost */
#define SPC_FEMPTY       0x800   /* Fifo empty */

         /* masks valid only for SPC7x0, SPC830, SPC140, SPC930 modules */
#define SPC_FBRDY        0x800   /* Flow back of scan finished */
#define SPC_SCRDY        0x400   /* Scan ready (data can be read ) */
#define SPC_MEASURE      0x40    /* Measurement active =
                                      no margin, no wait for trigger, armed */


#define SPC_WAIT_TRG     0x1000   /* wait for trigger */
#define SPC_HFILL_NRDY   0x2000   /* hardware fill not finished */
         /* masks valid only for SPC140, SPC930 modules */
#define SPC_SEQ_STOP     0x4000   /* disarmed (measurement stopped) by sequencer */


  /* sequencer state bits - returned from function SPC_get_sequencer_state  */
#define SPC_SEQ_ENABLE   0x1  /* sequencer is enabled */
#define SPC_SEQ_RUNNING  0x2  /* sequencer is running */
#define SPC_SEQ_GAP_BANK 0x4  /* sequencer is waiting for other bank to be armed */


    /*  initialisation error codes -
           - possible return values of function SPC_get_init_status */
#define INIT_OK                    0
#define INIT_NOT_DONE             -1 /* init not done */
#define INIT_WRONG_EEP_CHKSUM     -2 /* wrong EEPROM checksum */
#define INIT_WRONG_MOD_ID         -3 /* wrong module identification code */
#define INIT_HARD_TEST_ERR        -4 /* hardware test failed */
#define INIT_CANT_OPEN_PCI_CARD   -5 /* cannot open PCI card */
#define INIT_MOD_IN_USE           -6 /* module in use - cannot initialise */
#define INIT_WINDRVR_VER          -7 /* incorrect WinDriver version */
#define INIT_WRONG_LICENSE        -8 /* Wrong or missing license key */

#define INIT_XILINX_ERR           -100  // only for SPC-930 module
      // Xilinx chip configuration error -1xx - where xx = Xilinx error code   
      //   SPC has reduced functionality, when Xilinx chip is not configured





         /* mode values for SPC7xx, 830, 930 and 140 */
         
#define ROUT_IN   0           
#define ROUT_OUT  1  // for 830, 930 & 140 - FIFO mode         
#define SCAN_IN   2           
#define SCAN_OUT  3           
         
         /* mode values for SPC6xx */
         
#define NORMAL    0           
#define WIDE      1    // not implemented
#define FIFO_48   2    // 48 bits fifo type of SPC6x0       
#define FIFO_32   3    // 32 bits fifo type of SPC6x0        

         /* mode values for SPC130 */
         
#define NORMAL    0           
#define WIDE      1    // not implemented
#define FIFO130   2           

         /* additional mode values for SPC930 */
         
#define CAMERA_MODE   4   // camera mode

                      // in the moment there are no differences in data format
                      //    between following 3 fifo types
#define FIFO_130  4   // fifo type of SPC130
#define FIFO_830  5   // fifo type of SPC830 , 930
#define FIFO_140  6   // fifo type of SPC140

/*---------------------------------------------------------------------------*/

              /* structure for memory configuration parameters */
typedef struct _SPCMemConfig{   
  long   max_block_no;    /* total number of blocks per memory bank */
  long   blocks_per_frame; /* no of blocks per frame */
  long   frames_per_page;  /* no of frames per page */
  long   maxpage;         /* max number of pages to use in a measurement */
  short  block_length;    /* no of 16-bits words per one block */
  }SPCMemConfig;

typedef struct _SPCMemConfig *SPCMemConfigType;   

typedef struct _SPCdata{     /* structure for library data  */
  unsigned short base_adr;  /* base I/O address on PCI bus */
  short          init;       /* set to initialisation result code */
  float cfd_limit_low;   /* for SPCx3x(140) -500 .. 0mV ,for SPCx0x 5 .. 80mV */
  float cfd_limit_high;  /* 5 ..80 mV, default 80 mV , not for SPC130,140,930 */
  float cfd_zc_level;    /* SPCx3x(140) -96 .. 96mV, SPCx0x -10 .. 10mV */
  float cfd_holdoff;     /* SPCx0x: 5 .. 20 ns, other modules: no influence */
  float sync_zc_level;   /* SPCx3x(140): -96 .. 96mV, SPCx0x: -10..10mV */
  float sync_holdoff;    /* 4 .. 16 ns ( SPC130,140,930: no influence) */
  float sync_threshold;  /* SPCx3x(140): -500 .. -20mV, SPCx0x: no influence */
  float tac_range;       /* 50 .. 2000 ns */
  short sync_freq_div;   /* 1,2,4,8,16 ( SPC130,140,930: 1,2,4) */
  short tac_gain;        /* 1 .. 15  */
  float tac_offset;      /* 0 .. 100% */
  float tac_limit_low;   /* 0 .. 100% */
  float tac_limit_high;  /* 0 .. 100% */
  short adc_resolution;  /* 6,8,10,12 bits, default 10 ,  
                             (additionally 0,2,4 bits for SPC830,140,930 )*/
  short ext_latch_delay; /* 0 ..255 ns, SPC130: no influence */
                         /* SPC140,930: only values 0,10,20,30,40,50 ns are possible */
  float collect_time;    /* 0.0001 .. 100000s , default 0.01s */
  float display_time;    /* 0.0001 .. 100000s , default 0.01s */
  float repeat_time;     /* 0.0001 .. 100000s , default 0.01s */
  short stop_on_time;    /* 1 (stop) or 0 (no stop) */
  short stop_on_ovfl;    /* 1 (stop) or 0 (no stop) */
  short dither_range;    /* possible values - 0, 32,   64,   128,  256 
                               have meaning:  0, 1/64, 1/32, 1/16, 1/8   */
  short count_incr;      /* 1 .. 255 */
  short mem_bank;        /* for SPC130,600,630 :  0 , 1 , default 0
                            other SPC modules: always 0*/
  short dead_time_comp;  /* 0 (off) or 1 (on), default 1  */
  unsigned short scan_control; /* SPC505(535,506,536) scanning(routing) control word,
                                  other SPC modules always 0 */
  short routing_mode;     /* SPC230 0 (off) or 1 (on) 
                             other SPC modules always 0 */
  float tac_enable_hold;  /* SPC230 10.0 .. 265.0 ns - duration of
                             TAC enable pulse ,other SPC modules always 0 */
  short pci_card_no;      /* module no on PCI bus (0-7)  */
  unsigned short mode;    /* for SPC7x0      , default 0       
                                0 - normal operation (routing in), 
                                1 - block address out, 2 -  Scan In, 3 - Scan Out 
                             for SPC6x0      , default 0       
                                0 - normal operation (routing in)   
                                2 - FIFO mode 48 bits, 3 - FIFO mode 32 bits  
                             for SPC130      , default 0       
                                0 - normal operation (routing in)   
                                2 - FIFO mode 
                             for SPC830,140,930 , default 0       
                                0 - normal operation (routing in)   
                                1 - FIFO mode 32 bits, 2 -  Scan In, 3 - Scan Out  
                                4 - Camera mode ( only SPC930 )*/ 
  unsigned long scan_size_x;  /* for SPC7x0,830,140,930 modules in scanning modes 1 .. 65536, default 1 */
  unsigned long scan_size_y;  /* for SPC7x0,830,140,930 modules in scanning modes 1 .. 65536, default 1 */
  unsigned long scan_rout_x;  /* number of X routing channels in Scan In & Scan Out modes
                                  for SPC7x0,830,140,930 modules
                               1 .. 128, ( SPC7x0,830 ), 1 .. 16 (SPC140,930), default 1 */
  unsigned long scan_rout_y;  /* number of Y routing channels in Scan In & Scan Out modes
                                  for SPC7x0,830,140, 930 modules 
                               1 .. 128, ( SPC7x0,830 ), 1 .. 16 (SPC140,930), default 1 */
     /* INT(log2(scan_size_x)) + INT(log2(scan_size_y)) + 
        INT(log2(scan_rout_x)) + INT(log2(scan_rout_y)) <= max number of scanning bits
                        max number of scanning bits depends on current adc_resolution:
                                12 (10 for SPC7x0,140)   -              12
                                14 (12 for SPC7x0,140)   -              10
                                16 (14 for SPC7x0,140)   -               8
                                18 (16 for SPC7x0,140)   -               6
                                20 (18 for SPC140)       -               4
                                22 (20 for SPC140)       -               2
                                24 (22 for SPC140)       -               0
                                */
  unsigned long  scan_flyback;   /* for SPC7x0,830,140,930 modules in Scan Out or Rout Out mode, default 0 */
                                 /* bits 15-0  Flyback X in number of pixels
                                      bits 31-16 Flyback Y in number of lines */
  unsigned long  scan_borders;   /* for SPC7x0,830,140,930 modules in Scan In mode, default 0 */
                                 /* bits 15-0  Upper boarder, bits 31-16 Left boarder */
  unsigned short scan_polarity;    /* for SPC7x0,830,140,930 modules in scanning modes, default 0 */
                     /* bit 0 - polarity of HSYNC, bit 1 - polarity of VSYNC,
                        bit 2 - pixel clock polarity
                        bit = 0 - falling edge(active low)
                        bit = 1 - rising  edge(active high) */
  unsigned short pixel_clock;   /* for SPC7x0,830,140,930 modules in Scan In mode, 
                 pixel clock source, 0 - internal,1 - external, default 0 */
  unsigned short line_compression;   /* line compression factor for SPC7x0,830,140,930 modules 
                                   in Scan In mode,   1,2,4,8,16,32,64,128, default 1*/
  unsigned short trigger;    /* external trigger condition - 
           bits 1 & 0 mean :   00 - ( value 0 ) none(default), 
                               01 - ( value 1 ) active low, 
                               10 - ( value 2 ) active high 
        when sequencer is enabled on SPC130(6x0) modules additionally
          bits 9 & 8 of the value mean:
           00 - trigger only at the start of the sequence,
           01 ( 100 hex, 256 decimal ) - trigger on each bank
           11 ( 300 hex, 768 decimal ) - trigger on each curve in the bank
        for SPC140 and SPC130 (FPGA v. > C0) multi-module configuration 
               bits 13 & 12 of the value mean:
           x0 - module does not use trigger bus ( trigger defined via bits 0-1),
           01 ( 1000 hex, 4096 decimal ) - module uses trigger bus as slave 
                                            ( waits for the trigger on master),
           11 ( 3000 hex, 12288 decimal ) - module uses trigger bus as master
                                  ( trigger defined via bits 0-1),
                                  ( only one module can be the master )
          */
  float pixel_time;    /* pixel time in sec for SPC7x0,830,140,930 modules in Scan In mode,
                              50e-9 .. 1.0 , default 200e-9 */
  unsigned long ext_pixclk_div;  /* divider of external pixel clock for SPC7x0,830,140 modules
                                in Scan In mode, 1 .. 0x3fe, default 1*/
  float rate_count_time;    /* rate counting time in sec  default 1.0 sec
                              for SPC130,830,930 can be : 1.0, 250ms, 100ms, 50ms 
                              for SPC140 fixed to 50ms */
  short macro_time_clk;     /*  macro time clock definition for SPC130,140,830,930 in FIFO mode     
                              for SPC130, 140:
                                  0 - 50ns (default), 1 - SYNC freq., 2 - 1/2 SYNC freq.,
                                  3 - 1/4 SYNC freq., 4 - 1/8 SYNC freq.
                              for SPC830:
                                  0 - 50ns (default), 1 - SYNC freq., 
                              for SPC930:
                                  0 - 50ns (default), 1 - SYNC freq., 2 - 1/2 SYNC freq.*/
  short add_select;     /* selects ADD signal source for all modules except SPC930: 
                            0 - internal (ADD only), 1 - external */
  short test_eep;        /* test EEPROM checksum or not  */
  short adc_zoom;     /* selects ADC zoom level for module SPC830,140,930 default 0 
                           bit 4 = 0(1) - zoom off(on ), 
                           bits 0-3 zoom level =  
                               0 - zoom of the 1st 1/16th of ADC range,  
                              15 - zoom of the 16th 1/16th of ADC range */
  unsigned long img_size_x;  /* image X size ( SPC930 module in Camera mode ),
                                      1 .. 1024, default 1 */
  unsigned long img_size_y;  /* image Y size ( SPC930 module in Camera mode ),
                                actually equal to img_size_x ( quadratic image ) */
  unsigned long img_rout_x;  /* no of X routing channels ( SPC930 module in Camera mode ),
                                      1 .. 16, default 1 */
  unsigned long img_rout_y;  /* no of Y routing channels ( SPC930 module in Camera mode ),
                                      1 .. 16, default 1 */
  short xy_gain;      /* selects gain for XY ADCs for module SPC930, 1,2,4, default 1 */
  short master_clock;  /*  use Master Clock( 1 ) or not ( 0 ), default 0,
                               only for SPC140 multi-module configuration */
  short adc_sample_delay; /* ADC's sample delay, only for module SPC930 */
                          /* 0,10,20,30,40,50 ns (default 0 ) */
  short detector_type;    /* detector type used in Camera mode, only for module SPC930   
                                1 .. 9899, default 1, 
                      normally recognised automatically from the corresponding .bit file
                               1 - Hamamatsu Resistive Anode 4 channels detector
                               2 - Wedge & Strip 3 channels detector   */
  short x_axis_type;      /* X axis representation, only for module SPC930
                               0 - time (default ), 1 - ADC1 Voltage, 
                               2 - ADC2 Voltage, 3 - ADC3 Voltage, 4 - ADC4 Voltage */
  }SPCdata;  

              /* structure for module info */
typedef struct _SPCModInfo{   
  short    module_type;      /* module type */
  short    bus_number;       /* PCI bus number */
  short    slot_number;      /* slot number on PCI bus */
  short    in_use;           /* -1 used and locked by other application, 0 - not used 
                                 1 - in use  */
  short    init;             /* set to initialisation result code */
  unsigned short base_adr;   /* base I/O address */
  }SPCModInfo;


     /* structure containing SPC adjust parameters stored in EEPROM */
typedef struct _SPC_Adjust_Para{
  short vrt1;
  short vrt2;
  short vrt3;
  short dith_g;
  float gain_1;
  float gain_2;
  float gain_4;
  float gain_8;
  float tac_r0;
  float tac_r1;
  float tac_r2;
  float tac_r4;
  float tac_r8;
  short sync_div;
  }SPC_Adjust_Para;



   /* EEPROM data structure */

typedef struct _SPC_EEP_Data{  /* structure for SPC module EEPROM data  */
  char module_type[16];        /* SPC module type */
  char serial_no[16];          /* SPC module serial number */
  char date[16];               /* SPC module production date */
  SPC_Adjust_Para adj_para;       /* structure with adjust parameters */
  }SPC_EEP_Data;


         /* structure for the stream of photon files (.spc ) */
typedef struct {  
  short fifo_type;         // Fifo type: 2 (FIFO_48),  3 (FIFO_32), 
                           //            4 (FIFO_130), 5 (FIFO_830), 6 (FIFO_140)
  short bh_spc_type;       // 1- stream of BH .spc files ( 1st entry in each file 
                           //                 contains MT clock & rout.chan info)
                           // 0 - no special meaning of the first entry in the file
  int   mt_clock;          // macro time clock [0.1 ns] ( from the 1st photon entry )
  short rout_chan;         // number of used routing channels ( from the 1st photon entry )
  short ignore_invalid;    // do not read invalid photons 
  short no_of_files;       // number of files in stream
  short no_of_ready_files; // number of finished files ( all photons taken from already)
  char  base_name[260];    // base stream name 
  short first_no;          // first file number
  short cur_no;            // current file number
  char  cur_name[260];     // current file used to get photons
                           //   made from base_name and cur_no
  unsigned int  stream_size;  // total stream size in bytes ( all files)
  unsigned int  cur_stream_offs; // current offset in stream  in bytes ( all files)
  unsigned int  cur_file_offs;   // offset in the current file in bytes
  int   fifo_overruns;   // current number of Fifo overruns found in the stream
  int   invalid_phot;    // current number of invalid photons found in the stream
  int   read_photons;    // current number of read photons from the stream
  }PhotStreamInfo;



         /* structure for the photon data 
               read from the photons stream using SPC_get_photon function */
typedef struct {   
  unsigned long  mtime_lo;   /* macro time clocks low  32 bits */
  unsigned long  mtime_hi;   /* macro time clocks high 32 bits */
  unsigned short micro_time; /* micro time = 4095(255) - ADC value,  0-255 or 0-4095 */
  unsigned short rout_chan;  /* routing channel, 0-7, 
                              (0-31 for 4 SPC modules system, not for SPC-6x0)*/
  unsigned short flags;      /* photon flags, see defines below  */
  }PhotInfo;

          // photon flags defines
#define INV_PH   1         // Invalid Photon     
#define FI_OVR   2         // Fifo Overrun - data lost due to Fifo full



/*   SPC_LV_.. versions of the functions are prepared especially for usage 
          in LabView environment in 'Call Library' function node to avoid 
          problems with different strings representation in C and LabView 
          when using strings within clusters */

#ifndef LVSTR_DEFINED

#define LVSTR_DEFINED
typedef struct {     /* string definition in LabView */
  int   cnt;              /* number of bytes that follow */
  unsigned char str[1];   /* cnt bytes */
  } LVStr, *LVStrPtr, **LVStrHandle;
#endif

       /* LabView version of the structure for the stream of photons files (.spc ) */

typedef struct {   
  short fifo_type;         // Fifo type: 2 (FIFO_48),  3 (FIFO_32), 
                           //            4 (FIFO_130), 5 (FIFO_830), 6 (FIFO_140)
  short bh_spc_type;       // 1- stream of BH .spc files ( 1st entry in each file 
                           //                 contains MT clock & rout.chan info)
                           // 0 - no special meaning of the first entry in the file
  int   mt_clock;          // macro time clock [0.1 ns] ( from the 1st photon entry )
  short rout_chan;         // number of used routing channels ( from the 1st photon entry )
  short ignore_invalid;    // 1 - do not read invalid photons, 0 - read all photons 
  short no_of_files;       // number of files in stream
  short no_of_ready_files; // number of finished files ( all photons taken from already)
  LVStrHandle  base_name;    // handle to base stream name LabView string
  short first_no;          // first file number
  short cur_no;            // current file number
  LVStrHandle  cur_name;     // handle to current file used to get photons LabView string
                           //   made from base_name and cur_no
  unsigned int  stream_size;  // total stream size in bytes ( all files)
  unsigned int  cur_stream_offs; // current offset in stream  in bytes ( all files)
  unsigned int  cur_file_offs;   // offset in the current file in bytes
  int   fifo_overruns;   // current number of Fifo overruns found in the stream
  int   invalid_phot;    // current number of invalid photons found in the stream
  int   read_photons;    // current number of read photons from the stream
  }PhotStreamInfo_LV;


/*
 CVIDECL means C calling convention - default for C and C++ programs
 DLLSTDCALL means _stdcall calling convention which is required by Visual Basic
 
 The only difference between SPCstd_.. and SPC_.. functions is calling convention
                   
*/


/*- General functions -------------------------------------------------------*/

short   CVICDECL     SPC_init (char *ini_file);
short   DLLSTDCALL   SPCstd_init (char *ini_file);

short   CVICDECL     SPC_get_init_status(short mod_no);
short   DLLSTDCALL   SPCstd_get_init_status(short mod_no);

short   CVICDECL     SPC_get_parameters(short mod_no, SPCdata * data);
short   DLLSTDCALL   SPCstd_get_parameters(short mod_no, SPCdata * data);

short   CVICDECL     SPC_set_parameters(short mod_no, SPCdata *data);
short   DLLSTDCALL   SPCstd_set_parameters(short mod_no, SPCdata *data);

short   CVICDECL     SPC_get_parameter(short mod_no, short par_id , float * value);
short   DLLSTDCALL   SPCstd_get_parameter(short mod_no, short par_id , float * value);

short   CVICDECL     SPC_set_parameter(short mod_no, short par_id , float value);
short   DLLSTDCALL   SPCstd_set_parameter(short mod_no, short par_id , float value);

short   CVICDECL     SPC_configure_memory(short mod_no, short adc_resolution,
                        short no_of_routing_bits, SPCMemConfig  * mem_info);
short   DLLSTDCALL   SPCstd_configure_memory(short mod_no, short adc_resolution,
                        short no_of_routing_bits, SPCMemConfig  * mem_info);

short   CVICDECL     SPC_fill_memory(short mod_no, long block,long page,
                                   unsigned short fill_value);
short   DLLSTDCALL   SPCstd_fill_memory(short mod_no, long block,long page,
                                   unsigned short fill_value);

short   CVICDECL     SPC_read_block(short mod_no, long block, long frame, long page,
                             short from, short to, unsigned short *data);
short   DLLSTDCALL   SPCstd_read_block(short mod_no, long block, long frame, long page,
                             short from, short to, unsigned short *data);

short   CVICDECL     SPC_read_data_block(short mod_no,long block,long page,
                             short reduction_factor,short from, short to,
                             unsigned short *data);
short   DLLSTDCALL   SPCstd_read_data_block(short mod_no,long block,long page,
                             short reduction_factor,short from, short to,
                             unsigned short *data);

short   CVICDECL     SPC_write_data_block(short mod_no, long block, long page,
                             short from, short to, unsigned short *data);
short   DLLSTDCALL   SPCstd_write_data_block(short mod_no, long block, long page,
                             short from, short to, unsigned short *data);

short   CVICDECL     SPC_read_data_frame(short mod_no, long frame,long page,
                                    unsigned short *data);
short   DLLSTDCALL   SPCstd_read_data_frame(short mod_no, long frame,long page,
                                    unsigned short *data);

short   CVICDECL     SPC_read_data_page(short mod_no, long first_page,long last_page,
                                    unsigned short *data);
short   DLLSTDCALL   SPCstd_read_data_page(short mod_no, long first_page,long last_page,
                                    unsigned short *data);

short   CVICDECL     SPC_set_page(short mod_no, long page);
short   DLLSTDCALL   SPCstd_set_page(short mod_no, long page);

short   CVICDECL     SPC_get_sync_state(short mod_no, short *sync_state);
short   DLLSTDCALL   SPCstd_get_sync_state(short mod_no, short *sync_state);

short   CVICDECL     SPC_get_fifo_usage(short mod_no, float *usage_degree);
short   DLLSTDCALL   SPCstd_get_fifo_usage(short mod_no, float *usage_degree);

short   CVICDECL     SPC_get_scan_clk_state(short mod_no, short *scan_state);
short   DLLSTDCALL   SPCstd_get_scan_clk_state(short mod_no, short *scan_state);

short   CVICDECL     SPC_clear_rates(short mod_no);
short   DLLSTDCALL   SPCstd_clear_rates(short mod_no);

short   CVICDECL     SPC_read_rates(short mod_no, rate_values *rates);
short   DLLSTDCALL   SPCstd_read_rates(short mod_no, rate_values *rates);

short   CVICDECL     SPC_get_time_from_start(short mod_no, float *time);
short   DLLSTDCALL   SPCstd_get_time_from_start(short mod_no, float *time);

short   CVICDECL     SPC_get_break_time(short mod_no, float *time);
short   DLLSTDCALL   SPCstd_get_break_time(short mod_no, float *time);

short   CVICDECL     SPC_get_actual_coltime(short mod_no, float *time);
short   DLLSTDCALL   SPCstd_get_actual_coltime(short mod_no, float *time);

short   CVICDECL     SPC_test_state(short mod_no, short *state);
short   DLLSTDCALL   SPCstd_test_state(short mod_no, short *state);

short   CVICDECL     SPC_start_measurement(short mod_no);
short   DLLSTDCALL   SPCstd_start_measurement(short mod_no);

short   CVICDECL     SPC_pause_measurement(short mod_no);
short   DLLSTDCALL   SPCstd_pause_measurement(short mod_no);

short   CVICDECL     SPC_restart_measurement(short mod_no);
short   DLLSTDCALL   SPCstd_restart_measurement(short mod_no);

short   CVICDECL     SPC_stop_measurement(short mod_no);
short   DLLSTDCALL   SPCstd_stop_measurement(short mod_no);

short   CVICDECL     SPC_enable_sequencer(short mod_no, short enable);
short   DLLSTDCALL   SPCstd_enable_sequencer(short mod_no, short enable);

short   CVICDECL     SPC_get_sequencer_state(short mod_no, short *state);
short   DLLSTDCALL   SPCstd_get_sequencer_state(short mod_no, short *state);

short   CVICDECL     SPC_read_gap_time(short mod_no, float *time);
short   DLLSTDCALL   SPCstd_read_gap_time(short mod_no, float *time);

short   CVICDECL     SPC_get_eeprom_data(short mod_no, SPC_EEP_Data *eep_data);
short   DLLSTDCALL   SPCstd_get_eeprom_data(short mod_no, SPC_EEP_Data *eep_data);

short   CVICDECL     SPC_write_eeprom_data(short mod_no, unsigned short write_enable,
                                         SPC_EEP_Data *eep_data);
short   DLLSTDCALL   SPCstd_write_eeprom_data(short mod_no, unsigned short write_enable,
                                         SPC_EEP_Data *eep_data);

short   CVICDECL     SPC_get_adjust_parameters (short mod_no, SPC_Adjust_Para * adjpara);
short   DLLSTDCALL   SPCstd_get_adjust_parameters (short mod_no, SPC_Adjust_Para * adjpara);

short   CVICDECL     SPC_set_adjust_parameters (short mod_no, SPC_Adjust_Para * adjpara);
short   DLLSTDCALL   SPCstd_set_adjust_parameters (short mod_no, SPC_Adjust_Para * adjpara);

                   // for SPC130, SPC6x0, 830, 140 modules 
short   CVICDECL     SPC_read_fifo(short mod_no, unsigned long * count,unsigned short *data);
short   DLLSTDCALL   SPCstd_read_fifo(short mod_no, unsigned long * count,unsigned short *data);

/*- Low level functions -----------------------------------------------------*/
short   CVICDECL     SPC_test_id (short mod_no);
short   DLLSTDCALL   SPCstd_test_id (short mod_no);

short   CVICDECL     SPC_get_version (short mod_no, unsigned short *version);
short   DLLSTDCALL   SPCstd_get_version (short mod_no, unsigned short *version);


/*- Miscellaneous -----------------------------------------------------------*/

short   CVICDECL     SPC_get_module_info(short mod_no, SPCModInfo * mod_info);
short   DLLSTDCALL   SPCstd_get_module_info(short mod_no, SPCModInfo * mod_info);

short   CVICDECL     SPC_close (void);
short   DLLSTDCALL   SPCstd_close (void);

short   CVICDECL     SPC_set_mode(short mode, short force_use, int *in_use);
short   DLLSTDCALL   SPCstd_set_mode(short mode, short force_use, int *in_use);

short   CVICDECL     SPC_get_mode (void);
short   DLLSTDCALL   SPCstd_get_mode (void);

short   CVICDECL     SPC_get_error_string(short error_id, 
                                       char * dest_string, short max_length);
short   DLLSTDCALL   SPCstd_get_error_string(short error_id, 
                                       char * dest_string, short max_length);

short   CVICDECL     SPC_read_parameters_from_inifile( SPCdata *data, char *inifile);
short   DLLSTDCALL   SPCstd_read_parameters_from_inifile( SPCdata *data, char *inifile);

short   CVICDECL     SPC_save_parameters_to_inifile( SPCdata *data, 
                       char * dest_inifile, char *source_inifile, int with_comments);
short   DLLSTDCALL   SPCstd_save_parameters_to_inifile( SPCdata *data, 
                       char * dest_inifile, char *source_inifile, int with_comments);

short   CVICDECL     SPC_save_data_to_sdtfile ( short mod_no, 
                           unsigned short *data_buf, unsigned long bytes_no,
                           char *sdt_file );
short   DLLSTDCALL   SPCstd_save_data_to_sdtfile ( short mod_no, 
                           unsigned short *data_buf, unsigned long bytes_no,
                           char *sdt_file );

short   CVICDECL     SPC_init_phot_stream ( short fifo_type, char *spc_file,
                         short files_to_use, short bh_type, short ignore_invalid );
short   DLLSTDCALL   SPCstd_init_phot_stream ( short fifo_type, char *spc_file,
                         short files_to_use, short bh_type, short ignore_invalid );

short   CVICDECL     SPC_close_phot_stream ( short stream_hndl );
short   DLLSTDCALL   SPCstd_close_phot_stream ( short stream_hndl );

short   CVICDECL     SPC_get_phot_stream_info ( short stream_hndl, 
                                               PhotStreamInfo *stream_info );
short   DLLSTDCALL   SPCstd_get_phot_stream_info ( short stream_hndl, 
                                               PhotStreamInfo *stream_info );

short   CVICDECL     SPC_get_photon ( short stream_hndl, PhotInfo *phot_info );
short   DLLSTDCALL   SPCstd_get_photon ( short stream_hndl, PhotInfo *phot_info );

short   CVICDECL     SPC_get_detector_info ( short previous_type, short * det_type,
                                                   char * fname );
short   DLLSTDCALL   SPCstd_get_detector_info ( short previous_type, short * det_type,
                                                   char * fname );

/*- Functions for using in LabView         -----------------------------------*/
/*-           not needed in C environment  -----------------------------------*/

short   CVICDECL     SPC_LV_get_eeprom_data(short mod_no, char *module_type,
                       char *serial_no, char *date, SPC_Adjust_Para * adjpara);

short   CVICDECL     SPC_LV_get_phot_stream_info ( short stream_hndl, 
                                               PhotStreamInfo_LV *stream_info );

#ifdef __cplusplus
  }
#endif

/*- The End -----------------------------------------------------------------*/
