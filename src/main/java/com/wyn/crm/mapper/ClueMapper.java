package com.wyn.crm.mapper;


import com.wyn.crm.entity.Clue;
import com.wyn.crm.entity.ClueExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ClueMapper {
    int countByExample(ClueExample example);

    int deleteByExample(ClueExample example);

    int deleteByPrimaryKey(String id);

    int insert(Clue record);

    int insertSelective(Clue record);

    List<Clue> selectByExample(ClueExample example);

    Clue selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") Clue record, @Param("example") ClueExample example);

    int updateByExample(@Param("record") Clue record, @Param("example") ClueExample example);

    int updateByPrimaryKeySelective(Clue record);

    int updateByPrimaryKey(Clue record);

    List<Clue> getClueConditionPage(String fullname, String company, String phone, String source, String owner,
                                    String mphone, String state);

    List<Clue> getClueConditionPageByEntity(@Param("clue") Clue clue);

    Clue getClueCondition(String id);

    void deleteClueById(String clueId);
}