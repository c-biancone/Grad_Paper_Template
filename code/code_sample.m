% DBPSK Demodulation
cyclesPerBit = 5;
decoded_bits = [];
phase_change = 0;
angle_thresh = pi/4;

sig_bb = sig_bb .* exp(-1i * (pi/cyclesPerBit));

sig_angles = unwrap(angle(sig_bb));

for i = 2:length(sig_bb)
    phase_change = sig_angles(i) - sig_angles(i-1);

    if phase_change > angle_thresh % More than 45 degrees change, bit flipped
        decoded_bits = [decoded_bits, 0];
    elseif phase_change < -angle_thresh % Less than -45 degrees change, bit flipped
        decoded_bits = [decoded_bits, 1];
    else % idk
        decoded_bits = [decoded_bits, NaN];
    end

end

decoded_bits = rmmissing(decoded_bits);

key = [1 1 1 1 1 0 0 1 1 0 1 0 1];
key = repmat(key,[50,1]);
key = reshape(key, 1, []);

%% Perform matched filtering
matched_output = conv(decoded_bits, fliplr(key), 'full');

figure(2);
plot(matched_output);
box on;
title("Matched Filter Output", 'FontSize', 24);
ylab = ylabel("Magnitude");
xlab = xlabel("Sample");
% legend = legend("$signal(t)$");
set(xlab, 'Interpreter', 'latex');
set(ylab, 'Interpreter', 'latex');
set(legend, 'Interpreter', 'latex');
grid on;
set(gca, 'fontname', 'times');
axis square;
ax = gca;
ax.LineWidth = 2;