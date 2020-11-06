function plotThresh(figureNr, image, tresholds, t, imageName)

    figure(figureNr)
    
    %This if is the differenxe between
    if(t > 0)       
        gradmagntools = sqrt(Lv(gaussfft(image, t)));
        header = "Tresholded image w. Gaussian. Variance = " + t;
    
        
    else
        % Skips the Gaussian Filter if there is no variance value
        gradmagntools = sqrt(Lv(image));
        header = "Tresholded image unfiltered";      
    end
    
    for i = 1:4
        
        %Creates the subplots needed
        subplot(2, 2, i);
        
        if (i < 2) 
        	showgrey(gradmagntools);
            title(imageName)
            
        elseif (i < 3)
        	histogram(gradmagntools)
        	title("Histogram")
            
        else
        	showgrey((gradmagntools - tresholds(1, i - 2)) > 0);
        	title("Treshold = " + tresholds(1, i - 2));
        end
    end
    
    suptitle(header);
end
