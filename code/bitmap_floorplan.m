clear
figure;
floorplan_bitmap = flipud(imread('floorplan.png')); 
XWidth = size(floorplan_bitmap,2);
YWidth = size(floorplan_bitmap,1);
%px_per_m = 83.963;
px_per_m = 82.8333;
px_per_cm = px_per_m / 100;
XOffset = 683/px_per_m;
YOffset = (YWidth-2894)/px_per_m;
XRange = [-XOffset, XWidth/px_per_m-XOffset];
YRange = [-YOffset, YWidth/px_per_m-YOffset];
img_handle = imshow(floorplan_bitmap, 'XData', XRange, 'YData', YRange);
ax = gca;
ax.YDir = 'normal';
axis on

% XY-coordinates for measurement locations

% in pixels referring to 'floorplan.png'
x_px = [750, 750, 2100, 2300, 8050, 8050];

y_px = [2195, 2400, 1195, 2195, 2195, 500];

% offset of antenna position relative to measurement cart
% depends on measurement cart orientation relative to measurement location
% antennas are located in a line 20-60 cm distance from marked distance 
x_px_offset = [ 0, 0, 0, 0, 0, 0];
y_px_offset = [34, 34, 34, 34, 34, 34];

% offset due to wrong measuring device zero reference position
x_px_offset_meas = [ -9, -9, -9, -9, -9, -9]; 
y_px_offset_meas = [ 9, 9, 9, 9, 9, 9];
% in meters 
x_m = (x_px+x_px_offset+x_px_offset_meas) / px_per_m - XOffset;
y_m = (YWidth - y_px-y_px_offset-y_px_offset_meas) / px_per_m - YOffset;

% same for TX location
x_TX_px = 1500;
y_TX_px = 2238;
x_TX_m = x_TX_px / px_per_m - XOffset;
y_TX_m = (YWidth - y_TX_px) / px_per_m - YOffset;
 
hold on
plot(x_m, y_m, 'ro', 'MarkerFaceColor', 'r')
hold on
plot(x_TX_m, y_TX_m, 'b*', 'MarkerSize', 8, 'LineWidth', 1)
text(x_TX_m - 1.8, y_TX_m, sprintf('TX'), 'Color', 'b', 'FontSize', 10);

for i = 1:numel(x_m)
    text(x_m(i) + 0.3, y_m(i), sprintf('%d', i), 'Color', 'k', 'FontSize', 10);
end


data1 = [-50, -64, -48, -41, -72, 0];
data2 = [-55, -67, -67, -45, -68, 0];

tableText = ['Position  ', char(9), '2.4GHz(dBm)  ', char(9), '5GHz(dBm)  ', newline]; 

for i = 1:length(data1)
    if i == 6
        tableText = [tableText, sprintf('    %d\t          %s\t       %s\n', i, 'no signal', 'no signal')];
    else
        tableText = [tableText, sprintf('    %d\t              %d\t                %d\n', i, data1(i), data2(i))];
    end
end

dim = [0.1 0.65 0.4 0.3];
annotation('textbox', dim, 'String', tableText, 'FitBoxToText', 'on', 'EdgeColor', 'none', 'BackgroundColor', 'white');

grid minor
