function plotFunction(figureNr, image, scale, type, imageTitle, plotTitle) 
    
    % Creates the figure of which to plot in
    figure(figureNr)
    
    % Loop for subplotting
    for i = 1:6
        
        subplot(2, 3, i)
        
        if (i > 1)
            
            % This is if you want to do second order derivate 
            if (type == 0)
                contour(Lvvtilde(discgaussfft(image, scale(i - 1)), 'same'), [0, 0])
            
            %This is the third order derivate
            elseif (type == 1)
                showgrey(Lvvvtilde(discgaussfft(image, scale(i - 1)), 'same') < 0);
                
            else
                condition = Lvvvtilde(discgaussfft(image, scale(i - 1)), 'same') < 0;
                contour(Lvvtilde(discgaussfft(image, scale(i - 1)), 'same') + (~condition), [0, 0]);
            
            end
            
            axis('image')
            axis('ij')
            
            % Gives the figure a title for recognition of scale
            title("Scale = " + scale(i - 1));
            
        else
            
            showgrey(image)
            title(imageTitle)
            
        end
    end
    suptitle(plotTitle)
end