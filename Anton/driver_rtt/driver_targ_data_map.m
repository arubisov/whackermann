  function targMap = targDataMap(),

  ;%***********************
  ;% Create Parameter Map *
  ;%***********************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 4;
    sectIdxOffset = 0;
    
    ;%
    ;% Define dummy sections & preallocate arrays
    ;%
    dumSection.nData = -1;  
    dumSection.data  = [];
    
    dumData.logicalSrcIdx = -1;
    dumData.dtTransOffset = -1;
    
    ;%
    ;% Init/prealloc paramMap
    ;%
    paramMap.nSections           = nTotSects;
    paramMap.sectIdxOffset       = sectIdxOffset;
      paramMap.sections(nTotSects) = dumSection; %prealloc
    paramMap.nTotData            = -1;
    
    ;%
    ;% Auto data (loikxjbxjgn)
    ;%
      section.nData     = 24;
      section.data(24)  = dumData; %prealloc
      
	  ;% loikxjbxjgn.drive_speed_Value
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
	  ;% loikxjbxjgn.Gain1_Gain
	  section.data(2).logicalSrcIdx = 1;
	  section.data(2).dtTransOffset = 1;
	
	  ;% loikxjbxjgn.steer_speed_Value
	  section.data(3).logicalSrcIdx = 2;
	  section.data(3).dtTransOffset = 2;
	
	  ;% loikxjbxjgn.Gain_Gain
	  section.data(4).logicalSrcIdx = 3;
	  section.data(4).dtTransOffset = 3;
	
	  ;% loikxjbxjgn.robot_init_pose_Value
	  section.data(5).logicalSrcIdx = 4;
	  section.data(5).dtTransOffset = 4;
	
	  ;% loikxjbxjgn.mod_Value
	  section.data(6).logicalSrcIdx = 5;
	  section.data(6).dtTransOffset = 7;
	
	  ;% loikxjbxjgn.ToRadians_Gain
	  section.data(7).logicalSrcIdx = 6;
	  section.data(7).dtTransOffset = 8;
	
	  ;% loikxjbxjgn.robot_init_phi_Value
	  section.data(8).logicalSrcIdx = 7;
	  section.data(8).dtTransOffset = 9;
	
	  ;% loikxjbxjgn.Switch_Threshold
	  section.data(9).logicalSrcIdx = 8;
	  section.data(9).dtTransOffset = 10;
	
	  ;% loikxjbxjgn.path_Value
	  section.data(10).logicalSrcIdx = 9;
	  section.data(10).dtTransOffset = 11;
	
	  ;% loikxjbxjgn.ExecPath_Value
	  section.data(11).logicalSrcIdx = 10;
	  section.data(11).dtTransOffset = 131;
	
	  ;% loikxjbxjgn.RateLimiterSpeed_RisingLim
	  section.data(12).logicalSrcIdx = 11;
	  section.data(12).dtTransOffset = 132;
	
	  ;% loikxjbxjgn.RateLimiterSpeed_FallingLim
	  section.data(13).logicalSrcIdx = 12;
	  section.data(13).dtTransOffset = 133;
	
	  ;% loikxjbxjgn.RateLimiterSpeed_IC
	  section.data(14).logicalSrcIdx = 13;
	  section.data(14).dtTransOffset = 134;
	
	  ;% loikxjbxjgn.RateLimiterSteer_RisingLim
	  section.data(15).logicalSrcIdx = 14;
	  section.data(15).dtTransOffset = 135;
	
	  ;% loikxjbxjgn.RateLimiterSteer_FallingLim
	  section.data(16).logicalSrcIdx = 15;
	  section.data(16).dtTransOffset = 136;
	
	  ;% loikxjbxjgn.RateLimiterSteer_IC
	  section.data(17).logicalSrcIdx = 16;
	  section.data(17).dtTransOffset = 137;
	
	  ;% loikxjbxjgn.tometers_Gain
	  section.data(18).logicalSrcIdx = 17;
	  section.data(18).dtTransOffset = 138;
	
	  ;% loikxjbxjgn.ManualMode_Value
	  section.data(19).logicalSrcIdx = 18;
	  section.data(19).dtTransOffset = 139;
	
	  ;% loikxjbxjgn.Switch_Threshold_nyz2ccmjah
	  section.data(20).logicalSrcIdx = 19;
	  section.data(20).dtTransOffset = 140;
	
	  ;% loikxjbxjgn.robot_L_Value
	  section.data(21).logicalSrcIdx = 20;
	  section.data(21).dtTransOffset = 141;
	
	  ;% loikxjbxjgn.trigger_Value
	  section.data(22).logicalSrcIdx = 21;
	  section.data(22).dtTransOffset = 142;
	
	  ;% loikxjbxjgn.Gain_Gain_estuvp1kd1
	  section.data(23).logicalSrcIdx = 22;
	  section.data(23).dtTransOffset = 143;
	
	  ;% loikxjbxjgn.color_detect_threshold_Value
	  section.data(24).logicalSrcIdx = 23;
	  section.data(24).dtTransOffset = 144;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(1) = section;
      clear section
      
      section.nData     = 3;
      section.data(3)  = dumData; %prealloc
      
	  ;% loikxjbxjgn.Speaker_p2
	  section.data(1).logicalSrcIdx = 24;
	  section.data(1).dtTransOffset = 0;
	
	  ;% loikxjbxjgn.Speaker_p3
	  section.data(2).logicalSrcIdx = 25;
	  section.data(2).dtTransOffset = 1;
	
	  ;% loikxjbxjgn.Speaker_p4
	  section.data(3).logicalSrcIdx = 26;
	  section.data(3).dtTransOffset = 2;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(2) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% loikxjbxjgn.Speaker_p1
	  section.data(1).logicalSrcIdx = 27;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(3) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% loikxjbxjgn.robot_pose_reset_Value
	  section.data(1).logicalSrcIdx = 28;
	  section.data(1).dtTransOffset = 0;
	
	  ;% loikxjbxjgn.robot_phi_reset_Value
	  section.data(2).logicalSrcIdx = 29;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(4) = section;
      clear section
      
    
      ;%
      ;% Non-auto Data (parameter)
      ;%
    

    ;%
    ;% Add final counts to struct.
    ;%
    paramMap.nTotData = nTotData;
    


  ;%**************************
  ;% Create Block Output Map *
  ;%**************************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 2;
    sectIdxOffset = 0;
    
    ;%
    ;% Define dummy sections & preallocate arrays
    ;%
    dumSection.nData = -1;  
    dumSection.data  = [];
    
    dumData.logicalSrcIdx = -1;
    dumData.dtTransOffset = -1;
    
    ;%
    ;% Init/prealloc sigMap
    ;%
    sigMap.nSections           = nTotSects;
    sigMap.sectIdxOffset       = sectIdxOffset;
      sigMap.sections(nTotSects) = dumSection; %prealloc
    sigMap.nTotData            = -1;
    
    ;%
    ;% Auto data (n3qi1whofzj)
    ;%
      section.nData     = 14;
      section.data(14)  = dumData; %prealloc
      
	  ;% n3qi1whofzj.gm3k35cofu
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
	  ;% n3qi1whofzj.fqsyncqtm5
	  section.data(2).logicalSrcIdx = 1;
	  section.data(2).dtTransOffset = 3;
	
	  ;% n3qi1whofzj.knuczmltmq
	  section.data(3).logicalSrcIdx = 2;
	  section.data(3).dtTransOffset = 4;
	
	  ;% n3qi1whofzj.dy4pd40ssw
	  section.data(4).logicalSrcIdx = 3;
	  section.data(4).dtTransOffset = 5;
	
	  ;% n3qi1whofzj.edmn2outgy
	  section.data(5).logicalSrcIdx = 4;
	  section.data(5).dtTransOffset = 6;
	
	  ;% n3qi1whofzj.jmroiv3s4j
	  section.data(6).logicalSrcIdx = 5;
	  section.data(6).dtTransOffset = 10;
	
	  ;% n3qi1whofzj.bywfpokawn
	  section.data(7).logicalSrcIdx = 6;
	  section.data(7).dtTransOffset = 11;
	
	  ;% n3qi1whofzj.oi2sj02etm
	  section.data(8).logicalSrcIdx = 7;
	  section.data(8).dtTransOffset = 12;
	
	  ;% n3qi1whofzj.b5bk5yy350
	  section.data(9).logicalSrcIdx = 8;
	  section.data(9).dtTransOffset = 13;
	
	  ;% n3qi1whofzj.bflcw0hhni
	  section.data(10).logicalSrcIdx = 9;
	  section.data(10).dtTransOffset = 14;
	
	  ;% n3qi1whofzj.ogwqufpqp0
	  section.data(11).logicalSrcIdx = 10;
	  section.data(11).dtTransOffset = 15;
	
	  ;% n3qi1whofzj.pstx1iyyq4
	  section.data(12).logicalSrcIdx = 11;
	  section.data(12).dtTransOffset = 16;
	
	  ;% n3qi1whofzj.levxfcft02
	  section.data(13).logicalSrcIdx = 12;
	  section.data(13).dtTransOffset = 17;
	
	  ;% n3qi1whofzj.ps0x0uwz4z
	  section.data(14).logicalSrcIdx = 13;
	  section.data(14).dtTransOffset = 18;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(1) = section;
      clear section
      
      section.nData     = 3;
      section.data(3)  = dumData; %prealloc
      
	  ;% n3qi1whofzj.ahoydutrwi
	  section.data(1).logicalSrcIdx = 14;
	  section.data(1).dtTransOffset = 0;
	
	  ;% n3qi1whofzj.d2nc1uig3a
	  section.data(2).logicalSrcIdx = 15;
	  section.data(2).dtTransOffset = 1;
	
	  ;% n3qi1whofzj.cbbnyhgl5d
	  section.data(3).logicalSrcIdx = 16;
	  section.data(3).dtTransOffset = 2;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(2) = section;
      clear section
      
    
      ;%
      ;% Non-auto Data (signal)
      ;%
    

    ;%
    ;% Add final counts to struct.
    ;%
    sigMap.nTotData = nTotData;
    


  ;%*******************
  ;% Create DWork Map *
  ;%*******************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 3;
    sectIdxOffset = 2;
    
    ;%
    ;% Define dummy sections & preallocate arrays
    ;%
    dumSection.nData = -1;  
    dumSection.data  = [];
    
    dumData.logicalSrcIdx = -1;
    dumData.dtTransOffset = -1;
    
    ;%
    ;% Init/prealloc dworkMap
    ;%
    dworkMap.nSections           = nTotSects;
    dworkMap.sectIdxOffset       = sectIdxOffset;
      dworkMap.sections(nTotSects) = dumSection; %prealloc
    dworkMap.nTotData            = -1;
    
    ;%
    ;% Auto data (ew10rzwqr2t)
    ;%
      section.nData     = 4;
      section.data(4)  = dumData; %prealloc
      
	  ;% ew10rzwqr2t.ghfsfewmao
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
	  ;% ew10rzwqr2t.kibfrg0o4x
	  section.data(2).logicalSrcIdx = 1;
	  section.data(2).dtTransOffset = 3;
	
	  ;% ew10rzwqr2t.jceg31ca3v
	  section.data(3).logicalSrcIdx = 2;
	  section.data(3).dtTransOffset = 4;
	
	  ;% ew10rzwqr2t.hd2lhmxn3x.TimeStampA
	  section.data(4).logicalSrcIdx = 3;
	  section.data(4).dtTransOffset = 5;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(1) = section;
      clear section
      
      section.nData     = 3;
      section.data(3)  = dumData; %prealloc
      
	  ;% ew10rzwqr2t.iw4xkmjgxl.LoggedData
	  section.data(1).logicalSrcIdx = 4;
	  section.data(1).dtTransOffset = 0;
	
	  ;% ew10rzwqr2t.nnpg2wecja.LoggedData
	  section.data(2).logicalSrcIdx = 5;
	  section.data(2).dtTransOffset = 1;
	
	  ;% ew10rzwqr2t.dlkchlh2oe.LoggedData
	  section.data(3).logicalSrcIdx = 6;
	  section.data(3).dtTransOffset = 2;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(2) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% ew10rzwqr2t.jmgqvojjia.IcNeedsLoading
	  section.data(1).logicalSrcIdx = 7;
	  section.data(1).dtTransOffset = 0;
	
	  ;% ew10rzwqr2t.gx53drvqmg.IcNeedsLoading
	  section.data(2).logicalSrcIdx = 8;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(3) = section;
      clear section
      
    
      ;%
      ;% Non-auto Data (dwork)
      ;%
    

    ;%
    ;% Add final counts to struct.
    ;%
    dworkMap.nTotData = nTotData;
    


  ;%
  ;% Add individual maps to base struct.
  ;%

  targMap.paramMap  = paramMap;    
  targMap.signalMap = sigMap;
  targMap.dworkMap  = dworkMap;
  
  ;%
  ;% Add checksums to base struct.
  ;%


  targMap.checksum0 = 3272973878;
  targMap.checksum1 = 718149009;
  targMap.checksum2 = 1778013929;
  targMap.checksum3 = 2962002733;

