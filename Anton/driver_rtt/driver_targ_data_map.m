  function targMap = targDataMap(),

  ;%***********************
  ;% Create Parameter Map *
  ;%***********************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 3;
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
      section.nData     = 29;
      section.data(29)  = dumData; %prealloc
      
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
	
	  ;% loikxjbxjgn.robot_pose_reset_Value
	  section.data(5).logicalSrcIdx = 4;
	  section.data(5).dtTransOffset = 4;
	
	  ;% loikxjbxjgn.robot_init_pose_Value
	  section.data(6).logicalSrcIdx = 5;
	  section.data(6).dtTransOffset = 5;
	
	  ;% loikxjbxjgn.mod_Value
	  section.data(7).logicalSrcIdx = 6;
	  section.data(7).dtTransOffset = 8;
	
	  ;% loikxjbxjgn.ToRadians_Gain
	  section.data(8).logicalSrcIdx = 7;
	  section.data(8).dtTransOffset = 9;
	
	  ;% loikxjbxjgn.path_Value
	  section.data(9).logicalSrcIdx = 8;
	  section.data(9).dtTransOffset = 10;
	
	  ;% loikxjbxjgn.ExecPath_Value
	  section.data(10).logicalSrcIdx = 9;
	  section.data(10).dtTransOffset = 130;
	
	  ;% loikxjbxjgn.RateLimiterSpeed_RisingLim
	  section.data(11).logicalSrcIdx = 10;
	  section.data(11).dtTransOffset = 131;
	
	  ;% loikxjbxjgn.RateLimiterSpeed_FallingLim
	  section.data(12).logicalSrcIdx = 11;
	  section.data(12).dtTransOffset = 132;
	
	  ;% loikxjbxjgn.RateLimiterSpeed_IC
	  section.data(13).logicalSrcIdx = 12;
	  section.data(13).dtTransOffset = 133;
	
	  ;% loikxjbxjgn.ProportionalGain_Gain
	  section.data(14).logicalSrcIdx = 13;
	  section.data(14).dtTransOffset = 134;
	
	  ;% loikxjbxjgn.resetPID_Value
	  section.data(15).logicalSrcIdx = 14;
	  section.data(15).dtTransOffset = 135;
	
	  ;% loikxjbxjgn.Integrator_IC
	  section.data(16).logicalSrcIdx = 15;
	  section.data(16).dtTransOffset = 136;
	
	  ;% loikxjbxjgn.DerivativeGain_Gain
	  section.data(17).logicalSrcIdx = 16;
	  section.data(17).dtTransOffset = 137;
	
	  ;% loikxjbxjgn.Filter_IC
	  section.data(18).logicalSrcIdx = 17;
	  section.data(18).dtTransOffset = 138;
	
	  ;% loikxjbxjgn.FilterCoefficient_Gain
	  section.data(19).logicalSrcIdx = 18;
	  section.data(19).dtTransOffset = 139;
	
	  ;% loikxjbxjgn.RateLimiterSteer_RisingLim
	  section.data(20).logicalSrcIdx = 19;
	  section.data(20).dtTransOffset = 140;
	
	  ;% loikxjbxjgn.RateLimiterSteer_FallingLim
	  section.data(21).logicalSrcIdx = 20;
	  section.data(21).dtTransOffset = 141;
	
	  ;% loikxjbxjgn.RateLimiterSteer_IC
	  section.data(22).logicalSrcIdx = 21;
	  section.data(22).dtTransOffset = 142;
	
	  ;% loikxjbxjgn.IntegralGain_Gain
	  section.data(23).logicalSrcIdx = 22;
	  section.data(23).dtTransOffset = 143;
	
	  ;% loikxjbxjgn.tometers_Gain
	  section.data(24).logicalSrcIdx = 23;
	  section.data(24).dtTransOffset = 144;
	
	  ;% loikxjbxjgn.robot_L_Value
	  section.data(25).logicalSrcIdx = 24;
	  section.data(25).dtTransOffset = 145;
	
	  ;% loikxjbxjgn.trigger_Value
	  section.data(26).logicalSrcIdx = 25;
	  section.data(26).dtTransOffset = 146;
	
	  ;% loikxjbxjgn.Gain_Gain_puv2nszjpr
	  section.data(27).logicalSrcIdx = 26;
	  section.data(27).dtTransOffset = 147;
	
	  ;% loikxjbxjgn.color_detect_threshold_Value
	  section.data(28).logicalSrcIdx = 27;
	  section.data(28).dtTransOffset = 148;
	
	  ;% loikxjbxjgn.ManualMode_Value
	  section.data(29).logicalSrcIdx = 28;
	  section.data(29).dtTransOffset = 149;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(1) = section;
      clear section
      
      section.nData     = 3;
      section.data(3)  = dumData; %prealloc
      
	  ;% loikxjbxjgn.Speaker_p2
	  section.data(1).logicalSrcIdx = 29;
	  section.data(1).dtTransOffset = 0;
	
	  ;% loikxjbxjgn.Speaker_p3
	  section.data(2).logicalSrcIdx = 30;
	  section.data(2).dtTransOffset = 1;
	
	  ;% loikxjbxjgn.Speaker_p4
	  section.data(3).logicalSrcIdx = 31;
	  section.data(3).dtTransOffset = 2;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(2) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% loikxjbxjgn.Speaker_p1
	  section.data(1).logicalSrcIdx = 32;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(3) = section;
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
    nTotSects     = 3;
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
      section.nData     = 15;
      section.data(15)  = dumData; %prealloc
      
	  ;% n3qi1whofzj.gm3k35cofu
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
	  ;% n3qi1whofzj.lvn0erjx3i
	  section.data(2).logicalSrcIdx = 1;
	  section.data(2).dtTransOffset = 3;
	
	  ;% n3qi1whofzj.dleyb0bycf
	  section.data(3).logicalSrcIdx = 2;
	  section.data(3).dtTransOffset = 6;
	
	  ;% n3qi1whofzj.fqsyncqtm5
	  section.data(4).logicalSrcIdx = 3;
	  section.data(4).dtTransOffset = 7;
	
	  ;% n3qi1whofzj.edmn2outgy
	  section.data(5).logicalSrcIdx = 4;
	  section.data(5).dtTransOffset = 8;
	
	  ;% n3qi1whofzj.jmroiv3s4j
	  section.data(6).logicalSrcIdx = 5;
	  section.data(6).dtTransOffset = 12;
	
	  ;% n3qi1whofzj.bywfpokawn
	  section.data(7).logicalSrcIdx = 6;
	  section.data(7).dtTransOffset = 13;
	
	  ;% n3qi1whofzj.liwkkhai1u
	  section.data(8).logicalSrcIdx = 7;
	  section.data(8).dtTransOffset = 14;
	
	  ;% n3qi1whofzj.g1kjvcjdwq
	  section.data(9).logicalSrcIdx = 8;
	  section.data(9).dtTransOffset = 15;
	
	  ;% n3qi1whofzj.j1xcikkmmo
	  section.data(10).logicalSrcIdx = 9;
	  section.data(10).dtTransOffset = 16;
	
	  ;% n3qi1whofzj.oi2sj02etm
	  section.data(11).logicalSrcIdx = 10;
	  section.data(11).dtTransOffset = 17;
	
	  ;% n3qi1whofzj.glnyz21hs4
	  section.data(12).logicalSrcIdx = 11;
	  section.data(12).dtTransOffset = 18;
	
	  ;% n3qi1whofzj.pstx1iyyq4
	  section.data(13).logicalSrcIdx = 12;
	  section.data(13).dtTransOffset = 19;
	
	  ;% n3qi1whofzj.levxfcft02
	  section.data(14).logicalSrcIdx = 13;
	  section.data(14).dtTransOffset = 20;
	
	  ;% n3qi1whofzj.ps0x0uwz4z
	  section.data(15).logicalSrcIdx = 14;
	  section.data(15).dtTransOffset = 21;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(1) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% n3qi1whofzj.iiyz2tr3cb
	  section.data(1).logicalSrcIdx = 15;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(2) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% n3qi1whofzj.bxgrnzuuqo
	  section.data(1).logicalSrcIdx = 16;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(3) = section;
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
    sectIdxOffset = 3;
    
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
      
      section.nData     = 4;
      section.data(4)  = dumData; %prealloc
      
	  ;% ew10rzwqr2t.db0c21ttjp.LoggedData
	  section.data(1).logicalSrcIdx = 4;
	  section.data(1).dtTransOffset = 0;
	
	  ;% ew10rzwqr2t.iw4xkmjgxl.LoggedData
	  section.data(2).logicalSrcIdx = 5;
	  section.data(2).dtTransOffset = 1;
	
	  ;% ew10rzwqr2t.nnpg2wecja.LoggedData
	  section.data(3).logicalSrcIdx = 6;
	  section.data(3).dtTransOffset = 2;
	
	  ;% ew10rzwqr2t.dlkchlh2oe.LoggedData
	  section.data(4).logicalSrcIdx = 7;
	  section.data(4).dtTransOffset = 3;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(2) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% ew10rzwqr2t.jmgqvojjia.IcNeedsLoading
	  section.data(1).logicalSrcIdx = 8;
	  section.data(1).dtTransOffset = 0;
	
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


  targMap.checksum0 = 1417983241;
  targMap.checksum1 = 4205401564;
  targMap.checksum2 = 1404748239;
  targMap.checksum3 = 102437916;

