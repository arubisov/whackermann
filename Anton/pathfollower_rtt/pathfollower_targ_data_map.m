  function targMap = targDataMap(),

  ;%***********************
  ;% Create Parameter Map *
  ;%***********************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 1;
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
      section.nData     = 21;
      section.data(21)  = dumData; %prealloc
      
	  ;% loikxjbxjgn.steer_angle_Value
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
	  ;% loikxjbxjgn.drive_speed_Value
	  section.data(2).logicalSrcIdx = 1;
	  section.data(2).dtTransOffset = 1;
	
	  ;% loikxjbxjgn.Gain1_Gain
	  section.data(3).logicalSrcIdx = 2;
	  section.data(3).dtTransOffset = 2;
	
	  ;% loikxjbxjgn.ManualMode_Value
	  section.data(4).logicalSrcIdx = 3;
	  section.data(4).dtTransOffset = 3;
	
	  ;% loikxjbxjgn.robot_init_pose_Value
	  section.data(5).logicalSrcIdx = 4;
	  section.data(5).dtTransOffset = 4;
	
	  ;% loikxjbxjgn.path_Value
	  section.data(6).logicalSrcIdx = 5;
	  section.data(6).dtTransOffset = 8;
	
	  ;% loikxjbxjgn.ExecPath_Value
	  section.data(7).logicalSrcIdx = 6;
	  section.data(7).dtTransOffset = 128;
	
	  ;% loikxjbxjgn.robot_pose_reset_Value
	  section.data(8).logicalSrcIdx = 7;
	  section.data(8).dtTransOffset = 129;
	
	  ;% loikxjbxjgn.robot_init_pose_Valu_obzhygnvxx
	  section.data(9).logicalSrcIdx = 8;
	  section.data(9).dtTransOffset = 130;
	
	  ;% loikxjbxjgn.mod_Value
	  section.data(10).logicalSrcIdx = 9;
	  section.data(10).dtTransOffset = 133;
	
	  ;% loikxjbxjgn.ToRadians_Gain
	  section.data(11).logicalSrcIdx = 10;
	  section.data(11).dtTransOffset = 134;
	
	  ;% loikxjbxjgn.todegrees_Gain
	  section.data(12).logicalSrcIdx = 11;
	  section.data(12).dtTransOffset = 135;
	
	  ;% loikxjbxjgn.ProportionalGain_Gain
	  section.data(13).logicalSrcIdx = 12;
	  section.data(13).dtTransOffset = 136;
	
	  ;% loikxjbxjgn.resetPID_Value
	  section.data(14).logicalSrcIdx = 13;
	  section.data(14).dtTransOffset = 137;
	
	  ;% loikxjbxjgn.Integrator_IC
	  section.data(15).logicalSrcIdx = 14;
	  section.data(15).dtTransOffset = 138;
	
	  ;% loikxjbxjgn.DerivativeGain_Gain
	  section.data(16).logicalSrcIdx = 15;
	  section.data(16).dtTransOffset = 139;
	
	  ;% loikxjbxjgn.Filter_IC
	  section.data(17).logicalSrcIdx = 16;
	  section.data(17).dtTransOffset = 140;
	
	  ;% loikxjbxjgn.FilterCoefficient_Gain
	  section.data(18).logicalSrcIdx = 17;
	  section.data(18).dtTransOffset = 141;
	
	  ;% loikxjbxjgn.tometers_Gain
	  section.data(19).logicalSrcIdx = 18;
	  section.data(19).dtTransOffset = 142;
	
	  ;% loikxjbxjgn.robot_L_Value
	  section.data(20).logicalSrcIdx = 19;
	  section.data(20).dtTransOffset = 143;
	
	  ;% loikxjbxjgn.IntegralGain_Gain
	  section.data(21).logicalSrcIdx = 20;
	  section.data(21).dtTransOffset = 144;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(1) = section;
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
      section.nData     = 17;
      section.data(17)  = dumData; %prealloc
      
	  ;% n3qi1whofzj.cduvurvbdm
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
	  ;% n3qi1whofzj.ol5io0snft
	  section.data(2).logicalSrcIdx = 1;
	  section.data(2).dtTransOffset = 1;
	
	  ;% n3qi1whofzj.obonuxqmli
	  section.data(3).logicalSrcIdx = 2;
	  section.data(3).dtTransOffset = 2;
	
	  ;% n3qi1whofzj.fztafc2twf
	  section.data(4).logicalSrcIdx = 3;
	  section.data(4).dtTransOffset = 5;
	
	  ;% n3qi1whofzj.o31oj5xc0d
	  section.data(5).logicalSrcIdx = 4;
	  section.data(5).dtTransOffset = 8;
	
	  ;% n3qi1whofzj.fo4ki0qcfu
	  section.data(6).logicalSrcIdx = 5;
	  section.data(6).dtTransOffset = 9;
	
	  ;% n3qi1whofzj.ay0womtzpi
	  section.data(7).logicalSrcIdx = 6;
	  section.data(7).dtTransOffset = 10;
	
	  ;% n3qi1whofzj.pwccnec2pw
	  section.data(8).logicalSrcIdx = 7;
	  section.data(8).dtTransOffset = 11;
	
	  ;% n3qi1whofzj.h3ahg2oq0a
	  section.data(9).logicalSrcIdx = 8;
	  section.data(9).dtTransOffset = 12;
	
	  ;% n3qi1whofzj.jahorfyczt
	  section.data(10).logicalSrcIdx = 9;
	  section.data(10).dtTransOffset = 13;
	
	  ;% n3qi1whofzj.mdxg0afhh0
	  section.data(11).logicalSrcIdx = 10;
	  section.data(11).dtTransOffset = 14;
	
	  ;% n3qi1whofzj.c2yxv5prfv
	  section.data(12).logicalSrcIdx = 11;
	  section.data(12).dtTransOffset = 15;
	
	  ;% n3qi1whofzj.mh00bulf0c
	  section.data(13).logicalSrcIdx = 12;
	  section.data(13).dtTransOffset = 16;
	
	  ;% n3qi1whofzj.irxwifnfrz
	  section.data(14).logicalSrcIdx = 13;
	  section.data(14).dtTransOffset = 17;
	
	  ;% n3qi1whofzj.bx4adn0a2c
	  section.data(15).logicalSrcIdx = 14;
	  section.data(15).dtTransOffset = 18;
	
	  ;% n3qi1whofzj.kx5syfwacn
	  section.data(16).logicalSrcIdx = 15;
	  section.data(16).dtTransOffset = 19;
	
	  ;% n3qi1whofzj.kajpc2zak2
	  section.data(17).logicalSrcIdx = 16;
	  section.data(17).dtTransOffset = 20;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(1) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% n3qi1whofzj.pcqrqqmbk5
	  section.data(1).logicalSrcIdx = 17;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(2) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% n3qi1whofzj.bieoqqguio
	  section.data(1).logicalSrcIdx = 18;
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
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% ew10rzwqr2t.fxcqwi5hyt
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
	  ;% ew10rzwqr2t.famz1f4owb.TimeStampA
	  section.data(2).logicalSrcIdx = 1;
	  section.data(2).dtTransOffset = 3;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(1) = section;
      clear section
      
      section.nData     = 6;
      section.data(6)  = dumData; %prealloc
      
	  ;% ew10rzwqr2t.bcgvqv3j45.LoggedData
	  section.data(1).logicalSrcIdx = 2;
	  section.data(1).dtTransOffset = 0;
	
	  ;% ew10rzwqr2t.llxfmgmb4o.LoggedData
	  section.data(2).logicalSrcIdx = 3;
	  section.data(2).dtTransOffset = 1;
	
	  ;% ew10rzwqr2t.f1tzuf50zj.LoggedData
	  section.data(3).logicalSrcIdx = 4;
	  section.data(3).dtTransOffset = 2;
	
	  ;% ew10rzwqr2t.hg5bzvb4vx.LoggedData
	  section.data(4).logicalSrcIdx = 5;
	  section.data(4).dtTransOffset = 3;
	
	  ;% ew10rzwqr2t.n3jzzsf01g.LoggedData
	  section.data(5).logicalSrcIdx = 6;
	  section.data(5).dtTransOffset = 4;
	
	  ;% ew10rzwqr2t.lr3mczme1i.LoggedData
	  section.data(6).logicalSrcIdx = 7;
	  section.data(6).dtTransOffset = 5;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(2) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% ew10rzwqr2t.ok1zzu4pb2.IcNeedsLoading
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


  targMap.checksum0 = 642301156;
  targMap.checksum1 = 190643442;
  targMap.checksum2 = 870988268;
  targMap.checksum3 = 1190473842;

