function uninterferedSignal = mserdetection(interferedSignal,interferedIndex,channel)
signal = interferedSignal(:,:,channel);
[M,N] = size(signal);
regions = detectMSERFeatures(abs(signal));
Pattern = [];
regionsNum = length(regions.PixelList);
for i = 1:regionsNum
    region = regions.PixelList{i,1};
    len = size(region);
    for j = 1:len(1)
        position = region(j,:);
        Pattern(position(1),position(2)) = 1;
    end
end
Pattern = Pattern';
[m,n] = size(Pattern);
interferedPattern = zeros(M,N);
interferedPattern(1:m,1:n) = Pattern;
% get the inverse raised cosine window function
L = 4;
% win = InverseRaisedCosWindow(L,interferedPattern);
win = InverseRaisedCosWindow(L,interferedIndex);
uninterferedSignal = win .* signal;
end

function win = InverseRaisedCosWindow(L,interferedPattern)
% window size: L
[m,n] = size(interferedPattern);
win = ones(m,n);
dist = getNearstDistance(L,interferedPattern);
for i = 1:m
    for j = 1:n
        if dist(i,j) < L
            win(i,j) = sin(pi * dist(i,j) / (2 * L));
        end
    end
end
end

function dist = getNearstDistance(L,interferedPattern)
% get the distance matrix for nearest interfered sample
[m,n] = size(interferedPattern);
dist = ones(m,n) * (L + 1);
for i = 1:m
    for j = 1:n
        up = max(1,i-L);
        down = min(m,i+L);
        left = max(1,j-L);
        right = min(n,j+L);
        matrix = interferedPattern(up:down,left:right);
        [a,b] = find(matrix == 1);
        if ~isempty(a)
            len = length(a);
            for t = 1:len
                dis(t) = sqrt((a(t)+up-1-i)^2 + (b(t)+left-1-j)^2);
            end
            dis(find(dis == 0)) = []; % delete the point(i,j)
            min_value = min(dis);
            if min_value < L
                dist(i,j) = min_value;
            end
        end
    end
end
end

        
