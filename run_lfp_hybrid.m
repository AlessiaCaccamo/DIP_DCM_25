% PhD Mathematics and Statistics, Thesis Chapter 1, Alessia Caccamo, University of Exeter, January 2024
function DCM=run_lfp_hybrid(MOGA_params,nsim,data,freq) %Return DCM structure

DCM = [];
DCM.A = {[1],[1],[1]};
DCM.B = {};
DCM.C = 0;


DCM.xY.y{1} = data;% data
DCM.xY.Hz = freq; % frequency from 1 to 20 Hz
DCM.xY.dt = 1;


options.Nmodes       =1;% number of spatial modes
%options.Tdcm         [- [start end] time window in ms

options.Fdcm         = DCM.xY.Hz([1 end]);%[start end] Frequency window in Hz
options.D            =1;%- time bin decimation       (usually 1 or 2)
options.spatial      ='LFP';%- 'ECD', 'LFP' or 'IMG'     (see spm_erp_L)
options.model        ='LFP';%- 'ERP', 'SEP', 'CMC', 'LFP', 'NMM' or 'MFM'

DCM.options = options;

% check options
%==========================================================================
drawnow
clear spm_erp_L
name = sprintf('DCM_%s',date);
DCM.options.analysis  = 'CSD';
 
% Filename and options
%--------------------------------------------------------------------------
try, DCM.name;                      catch, DCM.name = name;      end
try, model   = DCM.options.model;   catch, model    = 'NMM';     end
try, spatial = DCM.options.spatial; catch, spatial  = 'LFP';     end
try, Nm      = DCM.options.Nmodes;  catch, Nm       = 8;         end
try, DATA    = DCM.options.DATA;    catch, DATA     = 1;         end

display(model); 
% Spatial model
%==========================================================================
DCM.options.Nmodes = Nm;
DCM.M.dipfit.model = model;
DCM.M.dipfit.type  = spatial;

if DATA
    %DCM  = spm_dcm_erp_data(DCM);                   % data
    %DCM  = spm_dcm_erp_dipfit(DCM, 1);              % spatial model
end

     % DCM.M.dipfit % the following fields are added to the structure,
     % e.g., DCM.M.dipfit.location

   dipfit.location =0;%- 0 or 1 for source location priors
   dipfit.symmetry =0;%- 0 or 1 for symmetry constraints on sources
   dipfit.modality='LFP';%- 'EEG', 'MEG', 'MEGPLANAR' or 'LFP'
   dipfit.type    ='LFP';%- 'ECD', 'LFP' or 'IMG''
   dipfit.symm    =0;%- distance (mm) for symmetry constraints (ECD)
   dipfit.Lpos    =0;%- x,y,z source positions (mm)            (ECD)
   dipfit.Nm      =1;%- number of modes                        (Imaging)
   dipfit.Ns      =1;%- number of sources
   dipfit.Nc      =1;%- number of channels

   dipfit.model=options.model;
DCM.M.dipfit = dipfit;

Ns   = length(DCM.A{1});                            % number of sources


% Design model and exogenous inputs
%==========================================================================
if ~isfield(DCM,'xU'),   DCM.xU.X = sparse(1 ,0); end
if ~isfield(DCM.xU,'X'), DCM.xU.X = sparse(1 ,0); end
if ~isfield(DCM,'C'),    DCM.C    = sparse(Ns,0); end
if isempty(DCM.xU.X),    DCM.xU.X = sparse(1 ,0); end
if isempty(DCM.xU.X),    DCM.C    = sparse(Ns,0); end

% Neural mass model
%==========================================================================
 
% prior moments on parameters
%--------------------------------------------------------------------------
[pE,pC]  = spm_dcm_neural_priors(DCM.A,DCM.B,DCM.C,model);
  
% check to see if neuronal priors have already been specified
%--------------------------------------------------------------------------
try
    if spm_length(DCM.M.pE) == spm_length(pE);
        pE = DCM.M.pE;
        pC = DCM.M.pC;
        fprintf('Using existing priors\n')
    end
end

% augment with priors on spatial model
%--------------------------------------------------------------------------
[pE,pC] = spm_L_priors(DCM.M.dipfit,pE,pC);
 
% augment with priors on endogenous inputs (neuronal) and noise
%--------------------------------------------------------------------------
[pE,pC] = spm_ssr_priors(pE,pC);

try
    if spm_length(DCM.M.pE) == spm_length(pE);
        pE = DCM.M.pE;
        pC = DCM.M.pC;
        fprintf('Using existing priors\n')
    end
end
 
% initial states and equations of motion
%--------------------------------------------------------------------------
[x,f]    = spm_dcm_x_neural(pE,model);

% check for pre-specified priors
%--------------------------------------------------------------------------
hE       = 8;
hC       = 1/128;
try, hE  = DCM.M.hE; hC  = DCM.M.hC; end
 
% create DCM
%--------------------------------------------------------------------------
DCM.M.IS = 'spm_csd_mtf';
DCM.M.g  = 'spm_gx_erp';
DCM.M.f  = f;
DCM.M.x  = x;
DCM.M.n  = length(spm_vec(x));
DCM.M.pE = pE;
DCM.M.pC = pC;
DCM.M.hE = hE;
DCM.M.hC = hC;
DCM.M.m  = Ns;

% specify M.u - endogenous input (fluctuations) and intial states
%--------------------------------------------------------------------------
DCM.M.u  = sparse(Ns,1);

%-Feature selection using principal components (U) of lead-field
%==========================================================================
 
% Spatial modes
%--------------------------------------------------------------------------
try
    DCM.M.U = spm_dcm_eeg_channelmodes(DCM.M.dipfit,Nm);
end
 
% get data-features (in reduced eigenspace)
%==========================================================================
%if DATA
%    DCM  = spm_dcm_csd_data(DCM);
%end
 
% scale data features (to a variance of about 8)
%--------------------------------------------------------------------------
% ccf      = spm_csd2ccf(DCM.xY.y,DCM.xY.Hz);
% scale    = max(spm_vec(ccf));
% DCM.xY.y = spm_unvec(8*spm_vec(DCM.xY.y)/scale,DCM.xY.y);


% complete model specification and invert
%==========================================================================
Nm       = size(DCM.M.U,2);                    % number of spatial modes
DCM.M.l  = Nm;
DCM.M.Hz = DCM.xY.Hz;
DCM.M.dt = DCM.xY.dt;
 
% normalised precision
%--------------------------------------------------------------------------
DCM.xY.Q  = spm_dcm_csd_Q(DCM.xY.y);
DCM.xY.X0 = sparse(size(DCM.xY.Q,1),0);

DCM.M.pE.J = [0 0 0 0 0 0 0 0 1 0 0 0 0];
pE.J=DCM.M.pE.J;
DCM.M.pC.J = [0.0312 0 0 0 0 0 0.0312 0 0 0 0 0 0];
pC.J = DCM.M.pC.J;

% Use MOGA-informed priors
params = struct(...
    'R', [MOGA_params(1,nsim),MOGA_params(2,nsim)],...
    'T', [MOGA_params(3,nsim), MOGA_params(4,nsim)],...
    'G', MOGA_params(5,nsim),...
    'H', [MOGA_params(6,nsim), MOGA_params(7,nsim), MOGA_params(8,nsim), MOGA_params(9,nsim), MOGA_params(10,nsim)],...
    'A', [MOGA_params(11,nsim), MOGA_params(12,nsim), MOGA_params(13,nsim)],...
    'C', 0,...
    'D', MOGA_params(14,nsim),...
    'I', MOGA_params(15,nsim),...
    'Lpos', [0; 0; 0],...
    'L', 1,...
    'J', [0 0 0 0 0 0 0 0 1 0 0 0 0],...
    'a', [MOGA_params(16,nsim); MOGA_params(17,nsim)],...
    'b', [MOGA_params(18,nsim); MOGA_params(19,nsim)],...
    'c', [MOGA_params(20,nsim); MOGA_params(21,nsim)],...
    'd', [MOGA_params(22,nsim); MOGA_params(23,nsim); MOGA_params(24,nsim); MOGA_params(25,nsim)],...
    'f', [MOGA_params(26,nsim); MOGA_params(27,nsim)]);
params.A=num2cell(params.A);
pE=params;
DCM.M.pE=pE;

var_d=ones(27,1);
params_2 = struct(...
    'R', [var_d(1),var_d(2)],...
    'T', [var_d(3), var_d(4)],...
    'G', var_d(5),...
    'H', [var_d(6), var_d(7), var_d(8), var_d(9), var_d(10)],...
    'A', [var_d(11), var_d(12), var_d(13)],...
    'C', 0,...
    'D', var_d(14),...
    'I', var_d(15),...
    'Lpos', [0; 0; 0],...
    'L', 64,...
    'J', [0.0312 0 0 0 0 0 0.0312 0 0 0 0 0 0],...
    'a', [var_d(16); var_d(17)],...
    'b', [var_d(18); var_d(19)],...
    'c', [var_d(20); var_d(21)],...
    'd', [var_d(22); var_d(23); var_d(24); var_d(25)],...
    'f', [var_d(26); var_d(27)]);
params_2.A=num2cell(params_2.A);
pC=params_2;
DCM.M.pC=pC;

tic;
%Variational Laplace: model inversion
%==========================================================================
[Qp,Cp,Eh,F] = spm_nlsi_GN(DCM.M,DCM.xU,DCM.xY);


% Data ID
%--------------------------------------------------------------------------
try
    try
        ID = spm_data_id(feval(DCM.M.FS,DCM.xY.y,DCM.M));
    catch
        ID = spm_data_id(feval(DCM.M.FS,DCM.xY.y));
    end
catch
    ID = spm_data_id(DCM.xY.y);
end
 
 
% Bayesian inference {threshold = prior} NB Prior on A,B and C = exp(0) = 1
%==========================================================================
warning('off','SPM:negativeVariance');
dp  = spm_vec(Qp) - spm_vec(pE);
Pp  = spm_unvec(1 - spm_Ncdf(0,abs(dp),diag(Cp)),Qp);
warning('on', 'SPM:negativeVariance');
 
 
% predictions (csd) and error (sensor space)
%--------------------------------------------------------------------------
Hc  = spm_csd_mtf(Qp,DCM.M,DCM.xU); % prediction
%Hc = log(Hc{1}); %log-scaled spectrum
Ec  = spm_unvec(spm_vec(DCM.xY.y) - spm_vec(Hc),Hc);     % prediction error
 
 
% predictions (source space - cf, a LFP from virtual electrode)
%--------------------------------------------------------------------------
M             = rmfield(DCM.M,'U'); 
M.dipfit.type = 'LFP';

M.U         = 1;
M.l         = Ns;
qp          = Qp;
qp.L        = ones(1,Ns);             % set virtual electrode gain to unity
qp.b        = qp.b - 32;              % and suppress non-specific and
qp.c        = qp.c - 32;              % specific channel noise

[Hs Hz dtf] = spm_csd_mtf(qp,M,DCM.xU);
%Hs = log(Hs{1});
% dtf= log(dtf{1});
[ccf pst]   = spm_csd2ccf(Hs,DCM.M.Hz);
[coh fsd]   = spm_csd2coh(Hs,DCM.M.Hz);
DCM.dtf     = dtf;
DCM.ccf     = ccf;
DCM.coh     = coh;
DCM.fsd     = fsd;
DCM.pst     = pst;
DCM.Hz      = Hz;

 
% store estimates in DCM
%--------------------------------------------------------------------------
DCM.Ep = Qp;                   % conditional expectation
DCM.Cp = Cp;                   % conditional covariance
DCM.Pp = Pp;                   % conditional probability
DCM.Hc = Hc;                   % conditional responses (y), channel space
DCM.Rc = Ec;                   % conditional residuals (y), channel space
DCM.Hs = Hs;                   % conditional responses (y), source space
DCM.Ce = exp(-Eh);             % ReML error covariance
DCM.F  = F;                    % Laplace log evidence
DCM.ID = ID;                   % data ID

%display(Qp.J);

DCM.runtime_dcm=toc;

% and save
%--------------------------------------------------------------------------
DCM.options.Nmodes = Nm;

% DCM.name = ['Grand_post-PL_LFP_MOGA_means_' num2str(i) '_' DCM.name];
%DCM.name = ['Grand_control_LFP_' num2str(i) '_' DCM.name];
%save(DCM.name, 'DCM', spm_get_defaults('mat.format'));

return

% NOTES: for population specific cross spectra
%--------------------------------------------------------------------------
M             = rmfield(DCM.M,'U'); 
M.dipfit.type = 'LFP';
M           = DCM.M;
M.U         = 1; 
M.l         = DCM.M.m;
qp          = DCM.Ep;
qp.L        = ones(1,M.l);              % set electrode gain to unity
qp.b        = qp.b - 32;                % and suppress non-specific and
qp.c        = qp.c - 32;                % specific channel noise

% specifying the j-th population in the i-th source
%--------------------------------------------------------------------------
i           = 1;
j           = 2;
qp.J{i}     = spm_zeros(qp.J{i});
qp.J{i}(j)  = 1;

[Hs Hz dtf] = spm_csd_mtf(qp,M,DCM.xU); % conditional cross spectra
% Hs = log(Hs{1});
% dtf= log(dtf{1});

[ccf pst]   = spm_csd2ccf(Hs,DCM.M.Hz); % conditional correlation functions
[coh fsd]   = spm_csd2coh(Hs,DCM.M.Hz); % conditional covariance

