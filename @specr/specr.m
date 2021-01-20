classdef specr < handle & matlab.mixin.SetGet
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        data
        label
        stats
    end
    
    methods
        function thisSpecr = specr()
            %SPECR Construct an instance of this class
            thisSpecr = spcrinitialize(thisSpecr);
        end        
        function setLabel(thisSpecr,varargin)
            %SETLABEL Sets the tag in the 'label' field
            %   setLabel(structTag)
            %       structTag is a structure containing tag info
            %   setLabel('labelName','labelValue')
            %       'labelName' - the name of label
            %       'labelValue' - the value of label
            %       this method set label for all the spectra in the same
            %       time
            %   setLabel('labelName','labelValue',[startSpec endSpect])
            %       by specifying startSpec and endSpect this method can
            %       set tags only to those specified spectra
            switch(class(varargin{1}))
                case 'struct' 
                    tagstruct = varargin{1}; 
                    tagnames = fieldnames(tagstruct); 
                    for j = 1:numel(tagnames) 
                        if isfield(thisSpecr.label,tagnames{j})
                            thisSpecr.label.(tagnames{j}) = tagstruct.(tagnames{j});                                
                        else
                            error(message('Specr:unrecognizedTagName', tagnames{ j }));
                        end
                    end
                case 'char'
                    if numel(varargin) > 3
                        error('Too many inputs')
                    elseif numel(varargin) == 3
                        scope = varargin{3};
                        if scope(2) > numel(thisSpecr.label.fileName)
                            warning('the number of tag is more than the number of spectra')
                        end
                    elseif numel(varargin) == 2
                        scope = [1,size(thisSpecr.data.spc{end},1)];
                    else 
                        error('Too few inputs')                        
                    end
                    thisSpecr.label.(varargin{1})(scope(1):scope(2)) = varargin(2);
            end
        end
        function delLabel(thisSpecr,varargin)
            %DELLABEL Deletes the tag ENTRIES in the 'label' field
            
            %   delLabel('labelName','labelValue')
            %       'labelName' - the name of label to be deleted
            %       this method deletes label for all the spectra in the same
            %       time
            %   delLabel('labelName',[startSpec endSpect])
            %       by specifying startSpec and endSpect this method can
            %       delete tags only to those specified spectra
            
            if numel(varargin) > 3
                error('Too many inputs')
            elseif numel(varargin) == 2
                scope = varargin{2};
                if scope(2) > numel(thisSpecr.label.fileName)
                    warning('the number of tag is more than the number of spectra')
                end
            elseif numel(varargin) == 1
                scope = [1,numel(thisSpecr.label.(varargin{1}))];
            else 
                error('Too few inputs')                        
            end
            thisSpecr.label.(varargin{1})(scope(1):scope(2)) = [];
           
        end
        function clear(thisSpecr)
            i = size(thisSpecr.label.history,2);
            for j = 1:i-1
                thisSpecr.delete(2)
            end
        end
        
        function [m,varargout] = getMean(thisSpecr,varargin)
            p = inputParser;            
            defaultData = length(thisSpecr.data.spc);
            addRequired(p,'thisSpecr',@isobject);
            addParameter(p,'data',defaultData,@isscalar);
            p.KeepUnmatched = false;
            parse(p,thisSpecr,varargin{:});            
            targetdata = p.Results.data;
            
            m = mean(thisSpecr.data.spc{targetdata},1);
            if nargout == 2                
                varargout{1} = mean(thisSpecr.data.wavenum{targetdata},1);
            elseif nargout > 2
                error('Too many output')
            end                
        end
        function expt = exportdata(thisSpecr,varargin)
        end
        function snr = getSNR(thisSpecr,varargin)
            % Parse input
            peakLow = 1625;
            peakHigh = 1715;
            lowerEdge = 1800;
            upperEdge = 2000;

            p = inputParser;

            defaultData = length(thisSpecr.data.spc);

            addRequired(p,'thisSpecr',@isobject);
            addParameter(p,'data',defaultData,@isscalar);
            p.KeepUnmatched = false;

            parse(p,thisSpecr,varargin{:});

            targetdata = p.Results.data;
            
            spc = thisSpecr.data.spc{targetdata};

            % Calculate SNR
            % Find minimum distance for lowerEdge
            [~, indexAtMin] = min(abs(thisSpecr.data.wavenum{targetdata} - lowerEdge),[],2);
            [~, indexAtMinPeak] = min(abs(thisSpecr.data.wavenum{targetdata} - peakLow),[],2);
            % Find minimum distance for upperEdge
            [~, indexAtMax] = min(abs(thisSpecr.data.wavenum{targetdata} - upperEdge),[],2);
            [~, indexAtMaxPeak] = min(abs(thisSpecr.data.wavenum{targetdata} - peakHigh),[],2);

            sp = spc(:,indexAtMin:indexAtMax); 
            st = std(sp,0,2);
            m = mean(sp,2);
            pk = max(spc(:,indexAtMinPeak:indexAtMaxPeak),[],2);

            % snr = abs((spc(:,861) - m)) ./ st;

            snr = abs((pk - m)) ./ st;
        end
        function n = getNum(thisSpecr,varargin)
            % Parse inputs
            p = inputParser;
            defaultData = length(thisSpecr.data.spc);
            addRequired(p,'thisSpecr',@isobject);
            addParameter(p,'data',defaultData,@isscalar);
            
            parse(p,thisSpecr,varargin{:});
            targetdata = p.Results.data;
            
            
            % Find the sample size
            n = size(thisSpecr.data.spc{targetdata},1);
        end
        function s = getStd(thisSpecr,varargin)
            % Parse inputs
            p = inputParser;
            defaultData = length(thisSpecr.data.spc);
            addRequired(p,'thisSpecr',@isobject);
            addParameter(p,'data',defaultData,@isscalar);
            
            parse(p,thisSpecr,varargin{:});
            targetdata = p.Results.data;
            
            
            % Find the sample size
            s = std(thisSpecr.data.spc{targetdata},0,2);
        end
        function s = getInt(thisSpecr,x,varargin)
            p = inputParser;
            
            defaultData = length(thisSpecr.data.spc);
            addRequired(p,'thisSpecr',@isobject);
            addRequired(p,'x',@isscalar);
            addParameter(p,'data',defaultData,@isscalar);
            p.KeepUnmatched = false;
            
            parse(p,thisSpecr,x,varargin{:});
            targetdata = p.Results.data;
            x = p.Results.x;
            
            
            [~, index] = min(abs(thisSpecr.data.wavenum{targetdata} - x),[],2);
            s = thisSpecr.data.spc{targetdata}(:,index:index);
        end
        
        importdata(thisSpecr,varargin)
        normalize(thisSpecr,varargin)
        trim(thisSpecr,lowerEdge,upperEdge,varargin)
        plot(thisSpecr,varargin)
        plotMean(thisSpecr,varargin)
        removeBg(thisSpecr,varargin)
        removeBgFOV(thisSpecr,varargin)
        removeOutliner(thisSpecr,varargin)
        removeLowSNR(thisSpecr,varargin)
        delete(thisSpecr,data2del)
        calibrate(thisSpecr,ref,varargin)
        interpolate(thisSpecr,x,varargin)

        
        
        
        
    end     
    methods (Static)
        
    end
end

