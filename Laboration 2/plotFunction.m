function plotFunction(figureNr, image, scale, type, imageTitle, plotTitle) 
    
    % Creates the figure of which to plot in
    figure(figureNr)
    
    % Loop for subplotting
    for i = 1:6
        
        subplot(2, 3, i)
        
        if (i > 1)
            
            % Second order derivate approximation /w gaussian
            if (type == 0)
                
                contour(Lvvtilde(discgaussfft(image, scale(i - 1)), 'same'), [0, 0])
            
            % Third order derivate approximation /w gaussian
            elseif (type == 1)
                
                showgrey(Lvvvtilde(discgaussfft(image, scale(i - 1)), 'same') < 0);
            
            % This is the combination of Second and Third order derivate
            else
                
                contour(Lvvtilde(discgaussfft(image, scale(i - 1)), 'same') + ~(Lvvvtilde(discgaussfft(image, scale(i - 1)), 'same') < 0), [0, 0]);
            
            end
            
            axis('image')
            axis('ij')
            
            % Gives the figure a title for recognition of scale
            title("Scale = " + scale(i - 1));
            
        else
            
            % Orgiginal image for reference
            showgrey(image)
            title(imageTitle)
            
        end
    end
    sgtitle(plotTitle)
end