gaAucSold = {};

gaAucSold.eventFrame = CreateFrame("Frame", "gaAucSold.eventFrame");
gaAucSold.eventFrame:RegisterEvent("CHAT_MSG_SYSTEM");

function gaAucSold.onEvent(self, event, text)
    if( string.match( text, "^A buyer has been found for your auction of " ) ) then
        gaCore.displayAnnouncement( "GAnnoSnd", "SYSTEM", "@#Sound\Interface\AuctionWindowOpen.ogg");
    end
end

gaAucSold.eventFrame:SetScript("OnEvent", gaAucSold.onEvent);