package com.wyn.crm.service.api;

import com.github.pagehelper.PageInfo;
import com.wyn.crm.entity.Clue;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/22
 */
public interface ClueService {

    List<Clue> getAllClue();

    PageInfo<Clue> getClueConditionPage(Clue clue, Integer pageNo, Integer pageSize);

    int addClue(Clue clue);

    Clue getClue(String id);

    void updateClue(Clue clue);

    void deleteClueInIdList(List<String> id);

    void addClueConvert(Map<String,Object> map);
}
