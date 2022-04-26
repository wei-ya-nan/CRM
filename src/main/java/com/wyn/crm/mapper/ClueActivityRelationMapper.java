package com.wyn.crm.mapper;

import com.wyn.crm.entity.ClueActivityRelation;
import com.wyn.crm.entity.ClueActivityRelationExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ClueActivityRelationMapper {
    int countByExample(ClueActivityRelationExample example);

    int deleteByExample(ClueActivityRelationExample example);

    int deleteByPrimaryKey(String id);

    int insert(ClueActivityRelation record);

    int insertSelective(ClueActivityRelation record);

    List<ClueActivityRelation> selectByExample(ClueActivityRelationExample example);

    ClueActivityRelation selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") ClueActivityRelation record, @Param("example") ClueActivityRelationExample example);

    int updateByExample(@Param("record") ClueActivityRelation record, @Param("example") ClueActivityRelationExample example);

    int updateByPrimaryKeySelective(ClueActivityRelation record);

    int updateByPrimaryKey(ClueActivityRelation record);

    int saveRelationByTwoId(@Param("list") List<ClueActivityRelation> list);

    List<ClueActivityRelation> selectClueActivityRelationByClueId(String clueId);

    void deleteClueActivityRelationByClueId(String clueId);
}