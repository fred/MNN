module VotesHelper

  def score_for(voteable)
    if voteable.respond_to?(:plusminus)
      score = voteable.plusminus
      if score > 0
        " <span class='vote-score positive-vote'>(+#{score})</span>"
      elsif score < 0
        " <span class='vote-score negative-vote'>(#{score})</span>"
      else
        ""
      end
    else
      ""
    end
  end

end